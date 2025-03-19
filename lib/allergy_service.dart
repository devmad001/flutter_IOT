import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardstar/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['BASE_URL'];

class AllergyService {
  static Future<Map<String, dynamic>> fetchAllergyResults(
      String allergens, String token) async {
    final url = '${baseUrl}/user/dish/search';
    print('Request URL: $url');
    print('Token: $token');
    print('Allergens: $allergens');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}'},
        body: jsonEncode({'allergens': allergens}),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to fetch allergy results. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error fetching allergy results: $e');
    }
  }
}
