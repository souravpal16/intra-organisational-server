import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

final URL = "192.168.0.124";
final PORT = 4002;

String onStartConnection() {
  return 'Listening for connections on ${URL}:${PORT}';
}

String onDoneConnection(String ip, int port) {
  return 'connection closed from ${ip}}:${port}';
}

class ClientSocket {
  String username;
  String ip;
  int port;
  bool decentralisedServer;
  bool decentralisedClient;
  bool groupMember;
  ClientSocket({
    required this.username,
    required this.ip,
    required this.port,
    this.decentralisedServer = false,
    this.decentralisedClient = false,
    this.groupMember = false,
  });
  void toggledServer() {
    decentralisedServer != decentralisedServer;
  }

  void toggledClient() {
    decentralisedClient != decentralisedClient;
  }
}

class Message {
  String id;
  String text;
  Message({required this.id, required this.text});
}

void main() async {
  final server = await ServerSocket.bind(URL, PORT);
  print(onStartConnection());

  Map<Socket, ClientSocket> clientList = {};

  server.listen((client) {
    handleConnection(client, clientList);
  });
}

void handleConnection(Socket client, Map<Socket, ClientSocket> clientList) {
  String ip = client.remoteAddress.address;
  int port = client.remotePort;
  client.listen(
    (Uint8List data) async {
      await Future.delayed(Duration(seconds: 1));

      final rawMessage = String.fromCharCodes(data);
      Map<String, dynamic> message = json.decode(rawMessage);
      String id = message['id'];
      String text = message['text'];

      if (id == '!username') {
        insertClient(clientList, text, client);
      } else if (id == '!enterGc') {
        clientList[client]?.groupMember = true;
      } else if (id == 'text') {
        sendClients(
          clientList,
          text,
          client,
        );
      } else if (id == '!startDserver') {
        //removeClient(clientList, client);
        toggleDserver(clientList, client);
      } else if (id == '!startDclient') {
        //removeClient(clientList, client);
        toggleDclient(clientList, client);
      } else if (id == '!exit') {
        //removeClient(clientList, client);
        originalConfig(clientList, client);
      } else if (id == '!open_server_info') {
        Map<String, String> m = getOpenServerInfo(clientList);
        final message = json.encode(m);
        client.write(message);
      }
    },
    onError: (error) {
      removeClient(clientList, client);
      print(error);
      client.close();
    },
    onDone: () {
      removeClient(clientList, client);
      print(onDoneConnection(ip, port));
      client.close();
    },
  );
}

void insertClient(
    Map<Socket, ClientSocket> clientList, String text, Socket client) {
  if (clientList.containsKey(client)) {
    return;
  }
  ClientSocket cs = ClientSocket(
      username: text,
      ip: client.remoteAddress.address,
      port: client.remotePort);
  clientList[client] = cs;
}

void sendClients(
    Map<Socket, ClientSocket> clientList, String text, Socket sender) {}

void removeClient(Map<Socket, ClientSocket> clientList, Socket client) {
  if (!clientList.containsKey(client)) {
    return;
  }
  clientList.remove(client);
}

void toggleDserver(Map<Socket, ClientSocket> clientList, Socket client) {
  clientList[client]?.toggledServer();
}

void toggleDclient(Map<Socket, ClientSocket> clientList, Socket client) {
  clientList[client]?.toggledClient();
}

void originalConfig(Map<Socket, ClientSocket> clientList, Socket client) {
  clientList[client]?.decentralisedServer = false;
  clientList[client]?.decentralisedClient = false;
  clientList[client]?.groupMember = false;
}

Map<String, String> getOpenServerInfo(Map<Socket, ClientSocket> clientList) {
  Map<String, String> m = {};
  clientList.forEach(
    (key, value) {
      if (value.decentralisedServer) {
        m[value.username] = "${value.ip}:${value.port}";
      }
    },
  );
  return m;
}

//message format from client: Groupchat
//{"id": "", "text":""}

//message from server to client: Groupchat
//{"username": , "text": ""}

//server has to send message of the form
//{"id": , "username": , "text"}