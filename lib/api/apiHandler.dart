import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class ApiHandler {
  static final ApiHandler _instance = ApiHandler._();

  factory ApiHandler() {
    return _instance;
  }

  ApiHandler._();

  static Future<String?> getCookie(
      String serverUrl, String username, String password) async {
    final url = Uri.parse(
        '$serverUrl/Self/login?username=$username&password=$password');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200 &&
          response.headers['set-cookie'] != null) {
        final cookie = response.headers['set-cookie'];
        // Optionally save the cookie in shared preferences here or handle it in the LoginPage
        return cookie;
      }
    } catch (e) {
      print('Error signing in: $e');
    }
    return null; // Return null if the request fails
  }
}
