import 'package:http/http.dart' as http;

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse(
      'https://app.lohn.at/Self/api/v1/firmengruppen/GF/firmen/1/dienstnehmer/6669'));
}
