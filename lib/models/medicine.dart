import 'dart:convert';
import 'dart:typed_data';

import 'package:ap_assistant/apis/medicines_api.dart';

class Medicine {
  final String id;
  final String name;
  final String imageUrl;
  final String patientId;
  final String description;
  final Uint8List? imageBytes;

  Medicine({
    this.imageBytes,
    required this.id,
    required this.name,
    this.imageUrl = "",
    this.patientId = "",
    required this.description,
  });

  String get fullImageUrl => Uri.http(MedicinesApi.baseUrl, imageUrl).toString();

  Medicine copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? patientId,
    String? description,
    Uint8List? imageBytes,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      patientId: patientId ?? this.patientId,
      imageBytes: imageBytes ?? this.imageBytes,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'patientId': patientId,
      'description': description,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      patientId: map['patientId'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Medicine.fromJson(String source) => Medicine.fromMap(json.decode(source));
}
