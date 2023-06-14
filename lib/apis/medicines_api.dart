import 'package:ap_assistant/models/medicine.dart';
import 'package:http/http.dart' as http;

class MedicinesApi {
  static const String baseUrl = "apassistant-001-site1.atempurl.com";

  static Future<Medicine> postMedicine(Medicine medicine) async {
    final imageUrl = await MedicinesApi.putImage(medicine.imageBytes!, medicine.id);
    medicine = medicine.copyWith(imageUrl: imageUrl);

    Uri uri = Uri.http(baseUrl, "/api/Medicines");

    final response = await http.post(
      uri,
      body: medicine.toJson(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return Medicine.fromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Medicine> putMedicine(Medicine medicine) async {
    if (medicine.imageBytes != null) {
      final imageUrl = await MedicinesApi.putImage(medicine.imageBytes!, medicine.id);
      medicine = medicine.copyWith(imageUrl: imageUrl);
    }

    Uri uri = Uri.http(baseUrl, "/api/Medicines");

    final response = await http.put(
      uri,
      body: medicine.toJson(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return Medicine.fromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<void> deleteMedicine(String id) async {
    Uri uri = Uri.http(baseUrl, "/api/Medicines/$id");

    final response = await http.delete(uri);

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<String> putImage(List<int> imageBytes, String id) async {
    Uri uri = Uri.http(baseUrl, '/api/Medicines/$id/Image');

    final multipartFile = http.MultipartFile.fromBytes("image", imageBytes, filename: "$id.png");
    final request = http.MultipartRequest("PUT", uri)..files.add(multipartFile);

    final response = await request.send();

    final responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return responseData.body;
    } else {
      throw Exception(responseData.body);
    }
  }
}
