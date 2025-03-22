import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SocketService {
  static SocketService? _instance;
  IO.Socket? socket;
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final NotificationService _notificationService = NotificationService.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlayerInitialized = false;

  SocketService._() {
    _initNotifications();
    _initAudioPlayer();
  }

  static SocketService get instance {
    _instance ??= SocketService._();
    return _instance!;
  }

  Future<void> _initNotifications() async {
    // Request notification permission for Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Create the notification channel with high importance
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'sensor_data_channel',
      'Sensor Data Notifications',
      description: 'Notifications for new sensor data',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    // Create the Android-specific notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

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

  Future<void> _initAudioPlayer() async {
    if (_isAudioPlayerInitialized) return;

    try {
      print('Initializing audio player...');
      await _audioPlayer.setSource(AssetSource('alert.mp3'));
      _isAudioPlayerInitialized = true;
      print('Audio player initialized successfully');
    } catch (e, stackTrace) {
      print('Error initializing audio player: $e');
      print('Stack trace: $stackTrace');
      _isAudioPlayerInitialized = false;
    }
  }

  Future<void> _playAudioAlert() async {
    if (!_isAudioPlayerInitialized) {
      await _initAudioPlayer();
    }

    if (_isAudioPlayerInitialized) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('alert.mp3'));
        print('Audio alert played successfully');
      } catch (e) {
        print('Error playing audio alert: $e');
        _isAudioPlayerInitialized = false;
      }
    } else {
      print('Audio player not initialized');
    }
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
      // Execute the callback
      callback(data);
    });
  }

  void emitEvent(String event, dynamic data) {
    socket?.emit(event, data);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
  }
}
