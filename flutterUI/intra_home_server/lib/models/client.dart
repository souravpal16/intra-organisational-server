import 'dart:io';
import 'dart:convert';

class ClientSocket {
  late Socket socket;
  Future<void> initialiseSocket(String url, int port) async {
    socket = await Socket.connect(url, port);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
  }

  String convertMapToString(String key, String message) {
    Map<String, String> m = {};
    m[key] = message;
    String finalMessage = json.encode(m);
    return finalMessage;
  }

  Map<String, dynamic> convertStringToMap(String message) {
    Map<String, dynamic> m = json.decode(message);
    return m;
  }

  void sendMessage(String text) {
    socket.write(convertMapToString('text', text));
  }

  void closeSocket() {
    socket.destroy();
  }
}
