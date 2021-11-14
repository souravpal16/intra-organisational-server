import 'package:flutter/material.dart';
import '../data/constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final title;
  AppBarWidget({this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        child: Icon(Icons.arrow_back),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: color1,
      title: Text(this.title),
      actions: [
        GestureDetector(
          child: Icon(Icons.exit_to_app_outlined),
          onTap: () {},
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(60);
}
