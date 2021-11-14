import 'package:flutter/material.dart';
import 'package:intra_home_server/data/constants.dart';
import 'package:intra_home_server/models/appBarWidget.dart';
import '../widgets/messageField.dart';
import 'dart:typed_data';
import '../data/messageList.dart';
import '../models/message.dart';

const routeName = 'chatScreen';

class ChatScreen extends StatelessWidget {
  late final clientSocket;

  @override
  Widget build(BuildContext context) {
    print('running chat screen');
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String username = args['username'];
    clientSocket = args['socket'];
    print(clientSocket.socket);
    print(username);
    return MyHomePage(
      clientSocket: clientSocket,
      username: username,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final clientSocket;
  final username;
  List<Message> userMessageList = [];
  MyHomePage({required this.clientSocket, required this.username});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void startListening() {
    try {
      widget.clientSocket.socket.listen(
        // handle data from the server
        (Uint8List data) {
          final serverResponse = String.fromCharCodes(data);
          Map<String, dynamic> m =
              widget.clientSocket.convertStringToMap(serverResponse);
          setState(() {
            widget.userMessageList.add(Message(
                username: m['username'], message: m['text'], isLeft: true));
          });
          print('${m['username']}: ${m['text']}');
        },

        // handle errors
        onError: (error) {
          print(error);
          try {
            widget.clientSocket.socket.close();
          } catch (e) {
            print('running error');
          }
          widget.userMessageList.clear();
        },

        // handle server ending connection
        onDone: () {
          print('Server left.');
          //widget.clientSocket.socket.close();
        },
      );
    } catch (e) {
      print("showing error in funtion");
      throw 'error';
    }
  }

  bool flag = true;
  @override
  void initState() {
    print('running initstate again');
    try {
      startListening();
    } catch (e) {
      print(e);
    }

    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _controller = new TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.clientSocket.sendMessage(_controller.text);
    }
  }

  late String textFieldText;
  @override
  void dispose() {
    widget.userMessageList.clear();
    setState(() {});
    print('dispose called');
    _controller.dispose();
    // widget.clientSocket.socket.close();
    super.dispose();
  }

  void onSubmittedFunction() {
    _sendMessage();
    widget.userMessageList.add(Message(
        username: widget.username, message: textFieldText, isLeft: false));
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '${widget.clientSocket.getOwnAddress}',
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
                itemCount: widget.userMessageList.length,
                itemBuilder: (context, index) {
                  return MessageField(
                    username: widget.userMessageList[index].username,
                    message: widget.userMessageList[index].message,
                    isLeft: widget.userMessageList[index].isLeft,
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'Message: '),
                      controller: _controller,
                      onSubmitted: (text) {
                        textFieldText = text;
                        onSubmittedFunction();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      onSubmittedFunction();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color1),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
