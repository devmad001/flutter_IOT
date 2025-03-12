import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MetricsProvider extends ChangeNotifier {
  static const String _metricsKey = 'temperature_unit';
  String _unit = 'CELSIUS';

  MetricsProvider() {
    _loadPreference();
  }

  String get unit => _unit;

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _unit = prefs.getString(_metricsKey) ?? 'CELSIUS';
    notifyListeners();
  }

  Future<void> setUnit(String unit) async {
    if (_unit != unit) {
      _unit = unit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_metricsKey, unit);
      notifyListeners();
    }
  }

  double convertTemperature(double celsius) {
    if (_unit == 'FAHRENHEIT') {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  String getTemperatureWithUnit(double celsius) {
    final temp = convertTemperature(celsius);
    return '${temp.toStringAsFixed(1)}°${_unit == 'CELSIUS' ? 'C' : 'F'}';
  }
}
