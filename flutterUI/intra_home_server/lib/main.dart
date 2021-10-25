import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import './client.dart';

void main() async {
  print("app running again");
  ClientSocket clientSocket = ClientSocket();
  await clientSocket.initialiseSocket('127.0.0.1', 4567);
  String username = 'Tester';
  clientSocket.socket
      .write(clientSocket.convertMapToString('username', username));
  // Socket socket = await Socket.connect('127.0.0.1', 4567);
  // print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
  runApp(MyApp(clientSocket: clientSocket));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ClientSocket clientSocket;
  MyApp({required this.clientSocket}) {}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(clientSocket: this.clientSocket),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final clientSocket;
  MyHomePage({required this.clientSocket});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Message {
  String username;
  String message;
  bool isLeft;
  Message(
      {required this.username, required this.message, required this.isLeft});
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = new TextEditingController();
  List<Message> userMessageList = [
    Message(username: 'adam', message: 'hello otis', isLeft: true),
    Message(username: 'otis', message: 'hello maueve', isLeft: true),
    Message(username: 'admin', message: 'mehraba everyone', isLeft: true),
  ];
  String username = "Tester";

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.clientSocket.sendMessage(_controller.text);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
    super.initState();
  }

  @override
  void dispose() {
    widget.clientSocket.socket.close();
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
                  userMessageList.add(Message(
                      username: username, message: text, isLeft: false));
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
