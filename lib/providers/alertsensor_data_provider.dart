import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AlertSensorDataProvider extends ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();
  List<Map<String, dynamic>> _sensorData = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _deviceID;
  // Getters
  List<Map<String, dynamic>> get sensorData => _sensorData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get deviceID => _deviceID;

  // Update sensor data
  void updateSensorData(dynamic data) async {
    try {
      if (data != null) {
        // Get user ID from secure storage
        final userId = await _secureStorage.read(key: 'userid');

        // Check if user ID matches restaurant_id
        if (userId == data['restaurant_id']?.toString()) {
          _deviceID = data['device_id']?.toString();
          // final List<Map<String, dynamic>> newSensorData = List.from(_sensorData);

          // final index = newSensorData
          //     .indexWhere((sensor) => sensor['dev_eui'] == data['device_eui']);

          // Map<String, dynamic> updatedSensor;

          // if (index != -1) {
          //   // Update existing sensor data
          //   updatedSensor = {
          //     ...newSensorData[index],
          //     'temperature': data['temperature']?.toString() ?? '--',
          //     'battery': data['battery']?.toString() ?? '--',
          //     'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
          //   };
          //   newSensorData[index] = updatedSensor;
          print("@@@");

          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = 'Error updating sensor data: $e';
      notifyListeners();
    }
  }
}
