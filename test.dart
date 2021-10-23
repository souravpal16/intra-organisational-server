import 'dart:convert';

void main() {
  print("hello world");
  Map<String, String> m = {};
  m['name'] = 'Sourav';
  m['message'] = 'hello, how are you';
  print(m);
  //String mapString = m.toString();
  String mapString = json.encode(m);
  if (mapString is String) {
    print("mapstring is string");
  } else {
    print("mapstring is not string");
  }
  var mapdecoded = json.decode(mapString);
  if (mapdecoded is Map) {
    print('mapdecoded is a map');
  } else {
    print("mapdecoded is not a map");
  }
}
