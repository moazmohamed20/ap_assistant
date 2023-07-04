import 'package:ap_assistant/models/patient.dart';
import 'package:http/http.dart' as http;

class PatientsApi {
  static const String baseUrl = "alzheimers-001-site1.atempurl.com";

  static Future<Patient> register(PatientRegisterRequest request) async {
    Uri uri = Uri.http(baseUrl, "/api/Patients/Register");

    final response = await http.post(
      uri,
      body: request.toJson(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return Patient.fromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Patient> login(PatientLoginRequest request) async {
    Uri uri = Uri.http(baseUrl, "/api/Patients/Login");

    final response = await http.post(
      uri,
      body: request.toJson(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return Patient.fromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }
}
