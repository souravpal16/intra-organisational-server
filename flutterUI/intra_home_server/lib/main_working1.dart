import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

void main() async {
  // modify with your true address/port
  //Socket sock = await Socket.connect('192.168.56.1', 10000);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'TcpSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  late Socket socket;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initialiseSocket() async {
    widget.socket = await Socket.connect('127.0.0.1', 4567);
    print(
        'Connected to: ${widget.socket.remoteAddress.address}:${widget.socket.remotePort}');
    widget.socket.listen(
      // handle data from the server
      (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              child: Text('hello world'),
            ),
            RaisedButton(
              child: Text('initialise socket'),
              onPressed: () {
                initialiseSocket();
              },
            ),
          ],
        ),
      ),
    );
  }
}
