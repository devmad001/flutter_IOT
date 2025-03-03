import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  static SocketService? _instance;
  IO.Socket? socket;
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  SocketService._();

  static SocketService get instance {
    _instance ??= SocketService._();
    return _instance!;
  }

  void initSocket(String token) {
    // Remove 'http://' or 'https://' from the base URL if present
    final cleanUrl = baseUrl.replaceAll(RegExp(r'^https?://'), '');

    socket = IO.io('http://158.220.90.252/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'path': "/socket.io",
      'forceNew': true,
      'reconnectionAttempts': 100,
      'timeout': 10000,
    });

    socket?.onConnect((_) {
      print('Socket connected');
    });

    socket?.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket?.onError((error) {
      print('Socket error: $error');
    });
  }

  void connect() {
    socket?.connect();
  }

  void disconnect() {
    socket?.disconnect();
  }

  void subscribeToEvent(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
  }

  void emitEvent(String event, dynamic data) {
    socket?.emit(event, data);
  }
}
