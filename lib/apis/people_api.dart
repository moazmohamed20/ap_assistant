import 'package:ap_assistant/models/person.dart';
import 'package:http/http.dart' as http;

class PeopleApi {
  static const String baseUrl = "alzheimers-001-site1.atempurl.com";

  static Future<Person> postPerson(Person person) async {
    String? frontUrl, leftUrl, rightUrl;
    if (person.face.leftBytes != null) {
      frontUrl = await PeopleApi.putPhoto(person.face.leftBytes!, person.id, FaceDirection.left);
    }
    if (person.face.rightBytes != null) {
      frontUrl = await PeopleApi.putPhoto(person.face.rightBytes!, person.id, FaceDirection.right);
    }
    if (person.face.frontBytes != null) {
      frontUrl = await PeopleApi.putPhoto(person.face.frontBytes!, person.id, FaceDirection.front);
    }
    person = person.copyWith(face: Face(leftUrl: leftUrl, rightUrl: rightUrl, frontUrl: frontUrl));

    Uri uri = Uri.http(baseUrl, "/api/People");

    final response = await http.post(
      uri,
      body: person.toJson(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return Person.fromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Person> putPerson(Person person) async {
    String? frontUrl, leftUrl, rightUrl;
    if (person.face.leftBytes != null) {
      frontUrl = await PeopleApi.putPhoto(person.face.leftBytes!, person.id, FaceDirection.left);
    }
    if (person.face.rightBytes != null) {
      frontUrl = await PeopleApi.putPhoto(person.face.rightBytes!, person.id, FaceDirection.right);
    }
    if (person.face.frontBytes != null) {
      frontUrl = await PeopleApi.putPhoto(person.face.frontBytes!, person.id, FaceDirection.front);
    }
    person = person.copyWith(face: Face(leftUrl: leftUrl, rightUrl: rightUrl, frontUrl: frontUrl));

    Uri uri = Uri.http(baseUrl, "/api/People");

    final response = await http.put(
      uri,
      body: person.toJson(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return Person.fromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<void> deletePerson(String id) async {
    Uri uri = Uri.http(baseUrl, "/api/People/$id");

    final response = await http.delete(uri);

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<String> putPhoto(List<int> imageBytes, String id, FaceDirection faceDirection) async {
    Uri uri = Uri.http(baseUrl, '/api/People/$id/Photo');

    final multipartFile = http.MultipartFile.fromBytes("photo", imageBytes, filename: "$id.png");
    final request = http.MultipartRequest("PUT", uri)
      ..fields["faceDirection"] = "${faceDirection.index}"
      ..files.add(multipartFile);

    final response = await request.send();

    final responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return responseData.body;
    } else {
      throw Exception(responseData.body);
    }
  }
}
