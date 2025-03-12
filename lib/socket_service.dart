import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SocketService {
  static SocketService? _instance;
  IO.Socket? socket;
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final NotificationService _notificationService = NotificationService.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SocketService._() {
    _initNotifications();
  }

  static SocketService get instance {
    _instance ??= SocketService._();
    return _instance!;
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        // Handle notification tap
      },
    );
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
      'auth': {'token': token},
    });

    // Initialize notification service
    _notificationService.init();

    // Set up connection event handlers
    socket?.onConnect((_) {
      print('Socket connected');
    });

    socket?.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket?.onError((error) {
      print('Socket error: $error');
    });

    // Subscribe to alert events at socket initialization
    socket?.on('alertSensorData', (data) {
      print('Received temperature alert: $data');
      _showNotificationForEvent('alertSensorData', data);
    });
  }

  void onConnect(Function() callback) {
    socket?.onConnect((_) {
      print('Socket connected');
      callback();
    });
  }

  void onDisconnect(Function() callback) {
    socket?.onDisconnect((_) {
      print('Socket disconnected');
      callback();
    });
  }

  void onError(Function(dynamic) callback) {
    socket?.onError((error) {
      print('Socket error: $error');
      callback(error);
    });
  }

  void connect() {
    socket?.connect();
  }

  void disconnect() {
    socket?.disconnect();
  }

  void subscribeToEvent(String event, Function(dynamic) callback) {
    socket?.on(event, (data) {
      print("Received event: $event");
      // Show notification for the received event
      _showNotificationForEvent(event, data);
      // Execute the callback
      callback(data);
    });
  }

  Future<void> _showNotificationForEvent(String event, dynamic data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'sensor_data_channel',
      'Sensor Data Notifications',
      channelDescription: 'Notifications for new sensor data',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    String title;
    String body;
    bool _visualAlerts = true;
      bool _audioAlerts = true;
    final prefs = await SharedPreferences.getInstance();
     _visualAlerts = prefs.getBool('visualAlerts') ?? true;
      _audioAlerts = prefs.getBool('audioAlerts') ?? true;

    print(_visualAlerts);
    if (event == 'alertSensorData' && _visualAlerts) {
      final deviceId = data['device_id'] ?? 'Unknown Device';
      final temperature = data['temperature']?.toString() ?? 'unknown';
      

      title = 'Temperature Alert!';
      body =
          'Device $deviceId: Temperature $temperature°C is outside range ';

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        platformChannelSpecifics,
      );
    }
  }

  void emitEvent(String event, dynamic data) {
    socket?.emit(event, data);
  }
}
