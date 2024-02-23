import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/zeitspeicher.dart';

import 'package:zeiterfassung_v1/hivedb/hivedb_test/offlinebuchung.dart';

import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

class ApiHandler {
  static final ApiHandler _instance = ApiHandler._();

  factory ApiHandler() {
    return _instance;
  }

  ApiHandler._();

//-----------------------GET COOKIE---------------------------------

  static Future<bool> getCookie(
      String serverUrl, String username, String password) async {
    final url = Uri.parse(
        '$serverUrl/Self/api/v1/login?username=$username&password=$password');
    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final cookieHeader = response.headers['set-cookie'];
        if (cookieHeader != null) {
          // Split the cookie string into individual cookies
          final cookies = cookieHeader
              .split(',')
              .where((c) => c.trim().isNotEmpty)
              .toList();

          // This will hold the correctly separated cookies
          List<String> separateCookies = [];

          // Reconstruct the cookies respecting the commas within the dates
          String? currentCookie;
          for (var c in cookies) {
            if (currentCookie != null) {
              if (c.startsWith(' ')) {
                currentCookie += ',' + c;
                continue;
              } else {
                separateCookies.add(currentCookie);
                currentCookie = null;
              }
            }
            if (c.contains(';') &&
                (c.contains('Expires') || c.contains('Max-Age'))) {
              currentCookie = c;
            } else {
              separateCookies.add(c);
            }
          }
          if (currentCookie != null) {
            separateCookies.add(currentCookie);
          }

          // Find the PLAY_SESSION cookie
          final playSessionCookie = separateCookies.firstWhere(
            (cookie) => cookie.startsWith('PLAY_SESSION'),
            orElse: () => '',
          );

          if (playSessionCookie.isNotEmpty) {
            final storage = FlutterSecureStorage();
            await storage.write(key: 'cookie', value: playSessionCookie);
            print(playSessionCookie);
            print("Login successful: ${response.statusCode}");
            return true;
          }
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error signing in: $e');
    }
    return false;
  }

//----------------------------GET DIENSTNEHMER-----------------------------

  static Future<void> fetchDienstnehmerData(String cookie) async {
    final url = Uri.parse("https://app.lohn.at/Self/api/v1/dienstnehmer");
    try {
      final response = await http.get(url, headers: {'Cookie': cookie});

      var dienstnehmerBox =
          await HiveFactory.openBox<Dienstnehmer>('dienstnehmertest');
      var dienstnehmerstammBox =
          await HiveFactory.openBox<Dienstnehmerstamm>('dienstnehmerstammtest');

      if (response.statusCode == 200) {
        await dienstnehmerBox.clear();
        await dienstnehmerstammBox.clear();

        // Decode the JSON response
        final List<dynamic> dataList = json.decode(response.body);

        // Iterate over each item in the decoded list
        for (var item in dataList) {
          // Extract dienstnehmer data
          final dienstnehmerData = item['dienstnehmer'];
          final Dienstnehmer dienstnehmer = Dienstnehmer(
            faKz: dienstnehmerData['faKz'],
            faNr: dienstnehmerData['faNr'],
            dnNr: dienstnehmerData['dnNr'],
          );

          // Add dienstnehmer to the Hive box
          await dienstnehmerBox.add(dienstnehmer);

          // Extract dienstnehmerstamm data
          final dienstnehmerstammData = item['dienstnehmerstamm'];
          final Dienstnehmerstamm dienstnehmerstamm = Dienstnehmerstamm(
            name: dienstnehmerstammData['name'],
            nachname: dienstnehmerstammData['nachname'],
          );
          // Add dienstnehmerstamm to the Hive box
          await dienstnehmerstammBox.add(dienstnehmerstamm);
        }

        // Close Hive boxes after operations
        HiveFactory.closeBox(dienstnehmerBox);
        HiveFactory.closeBox(dienstnehmerstammBox);
      } else {
        print('Failed to load Dienstnehmerdaten: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Dienstnehmerdata: $e');
    }
  }

//---------------------------- BUCHEN --------------------------------

  static Future<bool> buchen(
      {required Dienstnehmer dienstnehmer,
      required String buchungsdatum,
      required int zeitdatenId}) async {
    print(zeitdatenId);
    String apiUrl =
        "https://app.lohn.at/Self/api/v1/zeit/firmengruppen/${dienstnehmer.faKz}/firmen/${dienstnehmer.faNr}/dienstnehmer/${dienstnehmer.dnNr}/buchen?buchungsdatum=$buchungsdatum";
    try {
      final storage = FlutterSecureStorage();
      String? cookie = await storage.read(key: 'cookie');
      Map<String, String> headers = {};
      if (cookie != null) {
        headers['Cookie'] = cookie;
      }

      var response = await http.post(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        print("Buchung erfolgreich");
        return true;
      } else {
        print("Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Buchen: Exception occurred: $e");
      return false;
    }
  }

//---------------------------- ZEITDATEN --------------------------

  static Future<void> fetchZeitdaten(Dienstnehmer dienstnehmer) async {
    String url =
        "https://app.lohn.at/Self/api/v1/zeit/firmengruppen/${dienstnehmer.faKz}/firmen/${dienstnehmer.faNr}/dienstnehmer/${dienstnehmer.dnNr}/zeitdaten";

    final storage = FlutterSecureStorage();
    String? cookie = await storage.read(key: 'cookie');
    Map<String, String> headers = {};

    if (cookie != null) {
      headers['Cookie'] = cookie;
    }

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> zeitspeicher = data['zeitspeicher'];

      // Open the Hive box
      Box<Zeitspeicher> zeitspeicherBox =
          await HiveFactory.openBox<Zeitspeicher>('zeitspeicher');

      // Clear the existing items
      await zeitspeicherBox.clear();

      // Add new items to the box
      for (var item in zeitspeicher) {
        final Zeitspeicher zeitspeicherInstance = Zeitspeicher(
            nummer: item['nummer'], // Directly access 'nummer' from 'item'
            name: item['name']); // Directly access 'name' from 'item'
        print(
            "Adding to Hive: ${zeitspeicherInstance.name}, ${zeitspeicherInstance.nummer}");
        await zeitspeicherBox.add(zeitspeicherInstance);
      }
      print("Items in zeitspeicherBox: ${zeitspeicherBox.length}");

      // Close the box when done
      await HiveFactory.closeBox(zeitspeicherBox);
    } else {
      print('Failed to load ${response.statusCode}');
    }
  }


//----------------------CHECK CONNECTIVITY----------------------------

static Future <bool> checkConnectivity() async {

  String url =
        "https://app.lohn.at/Self/api/v1";

  try {
     final response = await http.get(Uri.parse(url));
    if (response.statusCode == 404) {
    print("Connection to internet established");
          return true;
     }
     else{
      print("No Connection, Offline Modus ${response.statusCode}" );
      return false;
     }
 
  }
catch(e){
      print("Check Connectivity: Exception occurred: $e");
return false;
}
}
}




Future<void> sendOfflineBuchungenToServer() async {
  Box<Buchungen> box = await HiveFactory.openBox<Buchungen>('offlinebuchung');

  List<Buchungen> buchungen = box.values.toList();

print("Soviele Offline Buchungen ${buchungen.length}");

  for (Buchungen buchung in buchungen) {
  // Create a Dienstnehmer object from the Buchungen data
  Dienstnehmer dienstnehmer = Dienstnehmer(
    faKz: buchung.faKz,
    faNr: buchung.faNr,
    dnNr: buchung.dnNr,
  );

  // Implement the logic to send booking to the server
  bool wasSuccessful = await ApiHandler.buchen(
    dienstnehmer: dienstnehmer,
    buchungsdatum: buchung.timestamp,
    zeitdatenId: buchung.nummer,
    // Include other necessary parameters
  );
print("Buchung geschickt!");
    if (wasSuccessful) {
      // If the booking was successfully sent, remove it from the box
      await buchung.delete(); // This removes the booking from the Hive box
    }
  }

  await HiveFactory.closeBox(box);
}