import 'package:flutter/material.dart';
import 'package:intra_home_server/models/appBarWidget.dart';
import '../models/client.dart';
import '../data/constants.dart';

class SocketConnectionAwaitPage extends StatefulWidget {
  @override
  _SocketConnectionAwaitPageState createState() =>
      _SocketConnectionAwaitPageState();
}

class _SocketConnectionAwaitPageState extends State<SocketConnectionAwaitPage> {
  Future<ClientSocket> _connection(String username) async {
    ClientSocket clientSocket = ClientSocket();
    await clientSocket.initialiseSocket('192.168.221.88', 4002);
    //String username = 'Tester';
    clientSocket.socket
        .write(clientSocket.convertMapToString('username', username));
    return clientSocket;
  }

  @override
  Widget build(BuildContext context) {
    print('running again');
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String username = args['username'];
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Main Menu',
      ),
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
                padding: EdgeInsets.only(top: 16),
                child: RichText(
                  text: TextSpan(
                    text: 'Result: ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'Connection Successful!',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '${username}: ${snapshot.data!.getServerAddress}',
                style: TextStyle(fontSize: 20),
              ),
              ButtonOptionWidget(
                username: username,
                data: snapshot.data,
                textLabel: 'Go To Chat Room',
                route: '/chatScreen',
              ),
              ButtonOptionWidget(
                username: username,
                data: snapshot.data,
                textLabel: 'Start P2P',
                route: '/P2PServerScreen',
              ),
              ButtonOptionWidget(
                username: username,
                data: snapshot.data,
                textLabel: 'Enter P2P',
                route: '/P2PClientScreen',
              ),
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
                child: Text('Error: connection unsuccessful ${snapshot.error}'),
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

class ButtonOptionWidget extends StatelessWidget {
  final username;
  final data;
  final textLabel;
  final route;
  ButtonOptionWidget({this.username, this.data, this.textLabel, this.route});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          route,
          arguments: {'username': username, 'socket': data},
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(spreadRadius: 1)],
          border: Border.all(color: color3, width: 3),
          borderRadius: BorderRadius.circular(20),
          color: color8,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Center(
          child: Text(
            textLabel,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
