import 'package:flutter/material.dart';

class Message {
  String username;
  String message;
  bool isLeft;
  Message(
      {required this.username, required this.message, required this.isLeft});
}

class MessageField extends StatelessWidget {
  final username;
  final message;
  final isLeft;
  MessageField({
    this.username,
    this.message,
    this.isLeft,
  });
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  this.message,
                  style: TextStyle(color: isLeft ? Colors.black : Colors.white),
                ),
              ],
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
