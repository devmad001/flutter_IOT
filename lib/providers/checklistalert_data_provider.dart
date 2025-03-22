import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChecklistAlertDataProvider extends ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();

  bool _isLoading = true;
  String? _errorMessage;
  String? _title;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get title => _title;

  // Update checklist data
  void updateChecklistData(dynamic data) async {
    try {
      if (data != null) {
        // Get user ID from secure storage
        final userId = await _secureStorage.read(key: 'userid');

        // Check if user ID matches restaurant_id
        if (userId == data['restaurantId']?.toString()) {
          print("%%%%%%%%%%%%%%");
          _title = data['type']?.toString();
          print(_title);
          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = 'Error updating checklist data: $e';
      notifyListeners();
    }
  }
}
