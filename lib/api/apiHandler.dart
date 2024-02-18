import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';




class ApiHandler {
  static final ApiHandler _instance = ApiHandler._();

  factory ApiHandler() {
    return _instance;
  }

  ApiHandler._();

  static Future<bool?> getCookie(String serverUrl, String username, String password) async {
  final url = Uri.parse('$serverUrl/Self/login?username=$username&password=$password');
  try {

    final response = await http.get(url);

    // Check if the response is successful and if the 'set-cookie' header is present
    if (response.statusCode == 200 && response.headers['set-cookie'] != null) {
      final cookie = response.headers['set-cookie'];
      // Save the cookie using flutter_secure_storage
      print(cookie);
      final storage = FlutterSecureStorage();
      await storage.write(key: 'cookie', value: cookie!);
      return true;
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error signing in: $e');
  }
  return false; // Return false if the request fails
}




static Future<void> fetchDienstnehmerData(String cookie) async {
    final url = Uri.parse("https://app.lohn.at/Self/api/v1/firmengruppen/GF/firmen/1/dienstnehmer/6669");
    
    try {
      final response = await http.get(
        url,
        headers: {'Cookie': cookie},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        var dienstnehmerBox = await Hive.box<Dienstnehmer>('dienstnehmertest');
        var dienstnehmerstammBox = await Hive.box<Dienstnehmerstamm>('dienstnehmerstammtest');

        final dienstnehmerData = data['dienstnehmer'];
        final dienstnehmer = Dienstnehmer(
          faKz: dienstnehmerData['faKz'],
          faNr: dienstnehmerData['faNr'],
          dnNr: dienstnehmerData['dnNr'],
        );
        await dienstnehmerBox.add(dienstnehmer);

        final dienstnehmerstammData = data['dienstnehmerstamm'];
        final dienstnehmerstamm = Dienstnehmerstamm(
          name: dienstnehmerstammData['name'],
          nachname: dienstnehmerstammData['nachname'],
        );
        await dienstnehmerstammBox.add(dienstnehmerstamm);

        print("tmm bruder");
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } 
}

}
