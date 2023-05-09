import 'package:ap_assistant/models/location.dart';
import 'package:http/http.dart' as http;

class LocationsApi {
  static const String baseUrl = "apassistant-001-site1.atempurl.com";

  static Future<Location?> getLocationOf(String id) async {
    Uri uri = Uri.http(baseUrl, "/api/Locations/$id");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Location.fromJson(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception(response.body);
    }
  }
}
