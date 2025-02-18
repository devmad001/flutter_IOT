// config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  // If BASE_URL isn't defined in your .env file, you can provide a fallback.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://192.168.0.172:3000/api/v1';
}
