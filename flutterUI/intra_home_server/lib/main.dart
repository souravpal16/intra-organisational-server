import 'package:flutter/material.dart';
import './messageField.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestPage(),
    );
  }
}

class TestPage extends StatelessWidget {
  List<Message> userMessageList = [
    Message(username: 'adam', message: 'hello otis', isLeft: true),
    Message(username: 'otis', message: 'hello maueve', isLeft: true),
    Message(username: 'admin', message: 'mehraba everyone', isLeft: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
    );
  }
}
