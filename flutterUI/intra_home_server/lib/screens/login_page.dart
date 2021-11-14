import 'package:flutter/material.dart';
import 'package:intra_home_server/models/appBarWidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Login Page',
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            LoginField(
                labelText: 'Email', onSubmittedFunction: (String text) {}),
            LoginField(
                labelText: 'Password', onSubmittedFunction: (String text) {}),
            LoginField(
              labelText: 'Username',
              onSubmittedFunction: (String text) {
                Navigator.pushNamed(context, '/socketConnectionPage',
                    arguments: {'username': text});
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginField extends StatefulWidget {
  final labelText;
  final onSubmittedFunction;
  LoginField({this.labelText, this.onSubmittedFunction});
  @override
  _LoginFieldState createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  final TextEditingController _controller = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          labelText: widget.labelText,
        ),
        controller: _controller,
        onSubmitted: widget.onSubmittedFunction,
      ),
    );
  }
}
