import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
final baseUrl = dotenv.env['BASE_URL'];
class AllergyService {
  static Future<Map<String, dynamic>> fetchAllergyResults(
      String allergens,String token   ) async {
    final url = '${baseUrl}/user/dish/search'+'?allergens=${allergens}';
  print(url);
  print(token);
    try {
      final response = await http.get(
        Uri.parse(url),
       headers: {'Authorization': 'Bearer ${token}'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch allergy results');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
