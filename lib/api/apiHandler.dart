import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

String _bearerToken = "";
String _urlPOST =
    "https://app.lohn.at/Self/login?username=NORRISCHU6669&password=cQkAEEWH§";
String _urlGET =
    "https://app.lohn.at/Self/api/v1/firmengruppen/GF/firmen/1/dienstnehmer/6669";

Future<http.Response> fetchDienstnehmer() async {
  return await http.get(
    Uri.parse(_urlGET),
    headers: {
      'Authorization': 'Bearer $_bearerToken',
    },
  );
}

Future<void> fetchBearerToken() async {
  final response = await http.post(Uri.parse(_urlPOST));

  print(response.body.toString());
}
