import 'package:flutter/material.dart';
import '../models/client.dart';

class SocketConnectionAwaitPage extends StatefulWidget {
  @override
  _SocketConnectionAwaitPageState createState() =>
      _SocketConnectionAwaitPageState();
}

class _SocketConnectionAwaitPageState extends State<SocketConnectionAwaitPage> {
  Future<ClientSocket> _connection(String username) async {
    ClientSocket clientSocket = ClientSocket();
    await clientSocket.initialiseSocket('192.168.0.124', 4002);
    //String username = 'Tester';
    clientSocket.socket
        .write(clientSocket.convertMapToString('username', username));
    return clientSocket;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String username = args['username'];
    return Scaffold(
      body: FutureBuilder<ClientSocket>(
        future: _connection(username),
        builder: (BuildContext context, AsyncSnapshot<ClientSocket> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Result: connection successful'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/chatScreen',
                    arguments: {'username': username, 'socket': snapshot.data},
                  );
                },
                child: Text('Go to chat room'),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: connection unsuccessful'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting connection...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
