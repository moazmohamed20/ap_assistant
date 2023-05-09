// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ap_assistant/models/medicine.dart';

class Patient {
  final String id;
  final String name;
  final String email;
  final List<Medicine> medicines;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.medicines,
  });

  Patient copyWith({
    String? id,
    String? name,
    String? email,
    List<Medicine>? medicines,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      medicines: medicines ?? this.medicines,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'medicines': medicines.map((x) => x.toMap()).toList(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      medicines: map['medicines'] != null ? List<Medicine>.from((map['medicines'] as List).map((x) => Medicine.fromMap(x))) : const [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) => Patient.fromMap(json.decode(source));
}

class PatientRegisterRequest {
  final String name;
  final String email;
  final String password;

  PatientRegisterRequest({required this.name, required this.email, required this.password});

  PatientRegisterRequest copyWith({String? name, String? email, String? password}) {
    return PatientRegisterRequest(name: name ?? this.name, email: email ?? this.email, password: password ?? this.password);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password};
  }

  factory PatientRegisterRequest.fromMap(Map<String, dynamic> map) {
    return PatientRegisterRequest(name: map['name'], email: map['email'], password: map['password']);
  }

  String toJson() => json.encode(toMap());

  factory PatientRegisterRequest.fromJson(String source) => PatientRegisterRequest.fromMap(json.decode(source));
}

class PatientLoginRequest {
  final String email;
  final String password;

  PatientLoginRequest({required this.email, required this.password});

  PatientLoginRequest copyWith({String? email, String? password}) {
    return PatientLoginRequest(email: email ?? this.email, password: password ?? this.password);
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }

  factory PatientLoginRequest.fromMap(Map<String, dynamic> map) {
    return PatientLoginRequest(email: map['email'], password: map['password']);
  }

  String toJson() => json.encode(toMap());

  factory PatientLoginRequest.fromJson(String source) => PatientLoginRequest.fromMap(json.decode(source));
}
