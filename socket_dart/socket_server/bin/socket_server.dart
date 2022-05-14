import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

//'127.0.0.1'
// InternetAddress.anyIPv4
final URL = '192.168.221.88';
int PORT = 4002;
void main() async {
  // bind the socket server to an address and port
  final server = await ServerSocket.bind(URL, PORT);
  print('Listening to connections on ${URL}:${PORT}');
  Map<Socket, String> clientList = {};
  // listen for clent connections to the server
  server.listen((client) {
    handleConnection(client, clientList);
  });
}


void handleConnection(Socket client, Map<Socket, String> clientList) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  // listen for events from the client
  client.listen(
    // handle data from the client
    (Uint8List data) async {
      await Future.delayed(Duration(seconds: 1));
      // print(data);
      // print(data.runtimeType);
      final messageTemp = String.fromCharCodes(data);
      Map<String, dynamic> message = json.decode(messageTemp);
      if (message.containsKey('username')) {
        insert(clientList, client, message['username']);
      } else {
        if (message['text'] == 'exit') {
          //client.write('${clientList[client]} Left!}');
          await sendToClients(
              clientList, client, '${clientList[client]} Left!}');
          clientList.remove(client);
          client.close();
        } else if (message['text'] == 'serverStart') {
          print(
              '${clientList[client]}:${client.remoteAddress.address}:${client.remotePort} initiated decentralised server');
        } else {
          if (message['text'] != '') {
            await sendToClients(clientList, client, message['text']);
            print('Text from ${clientList[client]}');
          }
        }
      }
    },

    // handle errors
    onError: (error) {
      print('An error occurred on ${clientList[client]} side.');
      clientList.remove(client);
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('${clientList[client]} left');
      clientList.remove(client);
      client.close();
    },
  );
}

Future<void> sendToClients(
    Map<Socket, String> clientList, Socket client, String message) async {
  clientList.forEach((key, value) {
    if (key != client) {
      String username = clientList[client] ?? '';
      key.write(convertMessageMapToString(username, message));
    }
  });
}

void insert(Map<Socket, String> clientList, Socket client, String username) {
  clientList[client] = username;
}

String convertMessageMapToString(String username, String message) {
  Map<String, String> m = {};
  m['username'] = username;
  m['text'] = message;
  String finalMessage = json.encode(m);
  return finalMessage;
}
