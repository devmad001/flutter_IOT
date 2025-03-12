import 'package:flutter/material.dart';
import '../socket_service.dart';
import 'sensor_data_provider.dart';

class SocketProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService.instance;
  bool _isConnected = false;
  String? _token;
  SensorDataProvider? _sensorDataProvider;

  bool get isConnected => _isConnected;

  void initSocket(String token, {SensorDataProvider? sensorDataProvider}) {
    _token = token;
    _sensorDataProvider = sensorDataProvider;
    _socketService.initSocket(token);
    _isConnected = true;

    // Setup auto-reconnect
    _socketService.onDisconnect(() {
      _isConnected = false;
      notifyListeners();
      // Try to reconnect
      _socketService.connect();
    });

    _socketService.onConnect(() {
      _isConnected = true;
      notifyListeners();
    });

    // Subscribe to sensor data updates if provider is available
    if (_sensorDataProvider != null) {
      subscribeToEvent('newSensorData', (data) {
        _sensorDataProvider?.updateSensorData(data);
      });
    }
    
    notifyListeners();
  }

  void disconnect() {
    _token = null;
    _socketService.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  void reconnect() {
    if (_token != null) {
      _socketService.connect();
    }
  }

  void subscribeToEvent(String event, Function(dynamic) callback) {
    _socketService.subscribeToEvent(event, callback);
  }

  void emitEvent(String event, dynamic data) {
    _socketService.emitEvent(event, data);
  }
}
