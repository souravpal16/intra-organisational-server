import 'package:flutter/material.dart';
import '../widgets/messageField.dart';
import 'dart:typed_data';
import '../data/messageList.dart';
import '../models/message.dart';

const routeName = 'chatScreen';

class ChatScreen extends StatelessWidget {
  late final clientSocket;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String username = args['username'];
    clientSocket = args['socket'];
    return MyHomePage(
      clientSocket: clientSocket,
      username: username,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final clientSocket;
  final username;
  MyHomePage({required this.clientSocket, required this.username});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void startListening() {
    widget.clientSocket.socket.listen(
      // handle data from the server
      (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        Map<String, dynamic> m =
            widget.clientSocket.convertStringToMap(serverResponse);
        setState(() {
          userMessageList.add(Message(
              username: m['username'], message: m['text'], isLeft: true));
        });
        print('${m['username']}: ${m['text']}');
      },

      // handle errors
      onError: (error) {
        print(error);
        widget.clientSocket.socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        widget.clientSocket.socket.destroy();
      },
    );
  }

  @override
  void initState() {
    startListening();
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _controller = new TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.clientSocket.sendMessage(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.clientSocket.socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: userMessageList.length,
                itemBuilder: (context, index) {
                  return MessageField(
                    username: userMessageList[index].username,
                    message: userMessageList[index].message,
                    isLeft: userMessageList[index].isLeft,
                  );
                },
              ),
            ),
            Container(
              child: TextField(
                decoration: InputDecoration(labelText: 'Message: '),
                controller: _controller,
                onSubmitted: (text) {
                  _sendMessage();
                  userMessageList.add(Message(
                      username: widget.username, message: text, isLeft: false));
                  _controller.clear();
                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
