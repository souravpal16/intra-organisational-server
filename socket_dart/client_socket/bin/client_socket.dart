import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

void main() async {
  // connect to the socket server
  print('Enter username: ');
  String? username = stdin.readLineSync();
  final socket = await Socket.connect('192.168.0.124', 4002);
  await sendMessage(socket, convertMessageToText('username', username));
  print('A new socket: ${socket.address.address}:${socket.port}');
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');


  // listen for responses from the server
  socket.listen(
    // handle data from the server
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      Map<String, dynamic> serverResponseDecoded = json.decode(serverResponse);
      print(
          '${serverResponseDecoded['username']}: ${serverResponseDecoded['text']}');
    },

    // handle errors
    onError: (error) {
      print(error);
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );

  String? messageFromClient = '';
  while (messageFromClient != 'exit') {
    messageFromClient = stdin.readLineSync();
    String messageToBeSent = convertMessageToText('text', messageFromClient);
    await sendMessage(socket, messageToBeSent);
  }
  //print('done');
}

Future<void> sendMessage(Socket socket, String message) async {
  //print('Client: $message');
  socket.write(message);
  await Future.delayed(Duration(seconds: 2));
}

String convertMessageToText(String key, String? value) {
  Map<String, String?> m = {};
  m[key] = value;
  String message = json.encode(m);
  return message;
}
