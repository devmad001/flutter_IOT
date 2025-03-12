import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    print(
        'LanguageProvider initialized with default locale: ${_currentLocale.languageCode}');
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLanguage = await _storage.read(key: 'language_code');
    print('Loading saved language from storage: $savedLanguage');
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
      print('Language updated to: ${_currentLocale.languageCode}');
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    print('Changing language to: $languageCode');
    if (_currentLocale.languageCode == languageCode) return;

    _currentLocale = Locale(languageCode);
    await _storage.write(key: 'language_code', value: languageCode);
    print(
        'Language changed and saved to storage: ${_currentLocale.languageCode}');
    notifyListeners();
  }
}
