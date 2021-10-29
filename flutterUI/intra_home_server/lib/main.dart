import 'package:flutter/material.dart';
import 'models/client.dart';
import './screens/final_socket_client_page.dart';
import './screens/socket_connection_page.dart';
import './screens/login_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intra Organisation Server',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/chatScreen': (context) => ChatScreen(),
        '/socketConnectionPage': (context) => SocketConnectionAwaitPage()
      },
    );
  }
}
