import 'package:flutter/material.dart';

class SensorDataProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _sensorData = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get sensorData => _sensorData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Update sensor data
  void updateSensorData(dynamic data) {
    try {
      if (data != null) {
        print(data);
        final List<Map<String, dynamic>> newSensorData = List.from(_sensorData);
        final index = newSensorData
            .indexWhere((sensor) => sensor['device_eui'] == data['device_eui']);

        Map<String, dynamic> updatedSensor;
        if (index != -1) {
          // Update existing sensor data
          updatedSensor = {
            ...newSensorData[index],
            'temperature': data['temperature']?.toString() ?? '--',
            'battery': data['battery']?.toString() ?? '--',
            'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
          };
          newSensorData[index] = updatedSensor;
        }

        _sensorData = newSensorData;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error updating sensor data: $e';
      notifyListeners();
    }
  }

  // Set initial sensor data
  void setSensorData(List<Map<String, dynamic>> data) {
    _sensorData = data;
    _isLoading = false;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }
}
