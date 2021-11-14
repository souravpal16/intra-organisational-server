import 'package:flutter/material.dart';
import '../data/constants.dart';

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
                Text(
                  username,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isLeft ? color8 : Colors.black),
                ),
                Text(
                  this.message,
                  style: TextStyle(color: isLeft ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: isLeft ? color3 : color9,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }
}
