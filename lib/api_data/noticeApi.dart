import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  IO.Socket? socket;

  SocketService._internal();

  void connectToSocket(Function(List<dynamic>) onNoticeUpdate) {
    socket = IO.io('http://192.168.200.45:8000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.onConnect((_) {
      print("Connected to the server");

      // Listen for real-time notice updates
      socket!.on('noticeUpdate', (data) {
        onNoticeUpdate(data);
      });
    });

    socket!.onDisconnect((_) {
      print("Disconnected from the server");
    });
  }

  void disconnect() {
    socket?.disconnect();
  }
}
