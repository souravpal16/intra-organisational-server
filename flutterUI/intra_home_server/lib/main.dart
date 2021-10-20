import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

void main() async {
  Socket socket = await Socket.connect('127.0.0.1', 4567);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
  runApp(MyApp(socket: socket));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Socket socket;
  MyApp({required this.socket}) {}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(socket: this.socket),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final socket;
  MyHomePage({required this.socket});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Message {
  String message;
  bool isLeft;
  Message({required this.message, required this.isLeft});
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = new TextEditingController();
  List<Message> userMessageList = [];

  List<String> serverMessageList = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.socket.write(_controller.text);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    widget.socket.listen(
      // handle data from the server
      (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        setState(() {
          userMessageList.add(Message(message: serverResponse, isLeft: true));
        });
        print('Server: $serverResponse');
      },

      // handle errors
      onError: (error) {
        print(error);
        widget.socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        widget.socket.destroy();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    widget.socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server'),
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
                  userMessageList.add(Message(message: text, isLeft: false));
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

class MessageField extends StatelessWidget {
  final message;
  final isLeft;
  MessageField({this.message, this.isLeft});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: 250),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              this.message,
              style: TextStyle(color: isLeft ? Colors.black : Colors.white),
            ),
          ),
          decoration: BoxDecoration(
            color: isLeft ? Colors.amber : Colors.purple,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }
}
