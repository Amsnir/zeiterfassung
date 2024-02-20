import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

class ApiHandler {
  static final ApiHandler _instance = ApiHandler._();

  factory ApiHandler() {
    return _instance;
  }

  ApiHandler._();

  static Future<bool?> getCookie(
      String serverUrl, String username, String password) async {
    final url = Uri.parse(
        '$serverUrl/Self/login?username=$username&password=$password');
    try {
      final response = await http.get(url);

      // Check if the response is successful and if the 'set-cookie' header is present
      if (response.statusCode == 200 &&
          response.headers['set-cookie'] != null) {
        const cookie2 =
            "PLAY_SESSION=94f47f0c4caf4ab36459c6f2a8f398c5e99f3684-___AT=021042df05682266dbbb6a951a6ba9455b1a6701&modulname=MA+Self+Service&bPwChange=true&___ID=c0ed605c-e127-4313-ba72-7073a0616609&username=NORRISCHU6669; Path=/;";
        final cookie = response.headers['set-cookie'];
        // Save the cookie using flutter_secure_storage
        print(cookie);
        final storage = FlutterSecureStorage();
        await storage.write(key: 'cookie', value: cookie2!);
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
    final url = Uri.parse(
        "https://app.lohn.at/Self/api/v1/firmengruppen/GF/firmen/1/dienstnehmer/6669");

    try {
      final response = await http.get(
        url,
        headers: {'Cookie': cookie},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        var dienstnehmerBox =
            await HiveFactory.openBox<Dienstnehmer>('dienstnehmertest');
        var dienstnehmerstammBox = await HiveFactory.openBox<Dienstnehmerstamm>(
            'dienstnehmerstammtest');

        final dienstnehmerData = data['dienstnehmer'];
        final dienstnehmer = Dienstnehmer(
          faKz: dienstnehmerData['faKz'],
          faNr: dienstnehmerData['faNr'],
          dnNr: dienstnehmerData['dnNr'],
        );
        await dienstnehmerBox.add(dienstnehmer);
        HiveFactory.closeBox(dienstnehmerBox);

        final dienstnehmerstammData = data['dienstnehmerstamm'];
        final dienstnehmerstamm = Dienstnehmerstamm(
          name: dienstnehmerstammData['name'],
          nachname: dienstnehmerstammData['nachname'],
        );
        await dienstnehmerstammBox.add(dienstnehmerstamm);
        HiveFactory.closeBox(dienstnehmerstammBox);

        print("tmm bruder");
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
