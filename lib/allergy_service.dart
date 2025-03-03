import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alpha/config.dart';

class AllergyService {
  static Future<Map<String, dynamic>> fetchAllergyResults(
      String allergens) async {
    final url = '${Config.baseUrl}/user/allergy-check';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'allergens': allergens}),
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
