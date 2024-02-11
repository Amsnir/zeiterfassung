import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiHandler {
  static final ApiHandler _instance = ApiHandler._();

  factory ApiHandler() {
    return _instance;
  }

  ApiHandler._();

  static Future<bool?> getCookie(String serverUrl, String username, String password) async {
    final url = Uri.parse(
        '$serverUrl/Self/login?username=$username&password=$password');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200 &&
          response.headers['set-cookie'] != null) {
        final cookie = response.headers['set-cookie'];
       // Save the cookie in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cookie', cookie!);
        return true; 
      }
    } catch (e) {
      print('Error signing in: $e');
    }
    return false; // Return false if the request fails
  }


static Future<Map<String, dynamic>?> fetchDienstnehmerData(String cookie) async {
    // Your specific URL
    final url = Uri.parse("https://app.lohn.at/Self/api/v1/firmengruppen/GF/firmen/1/dienstnehmer/6669");
    
    try {
      final response = await http.get(
        url,
        headers: {'Cookie': cookie},
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }

}
