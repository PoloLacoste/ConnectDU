import 'dart:io';

void main() async {
  const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRpdGkiLCJpYXQiOjE2MTEwNDg0NTQsImV4cCI6MTYxMTEzNDg1NH0.zG-CPfHbhC2pk1BYoDMA3Nrj8h1y9r7euHD-Pix1Gf4";

  final socket=  await WebSocket.connect("ws://localhost/collect", headers: {
    "Authorization": "Bearer $token"
  });

  socket.listen(print,
  onDone: () async {
    await socket.close();
  },
  onError: (e) async {
    print(e);
    await socket.close();
  });
}