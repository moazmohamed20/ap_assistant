import 'dart:convert';
import 'dart:typed_data';

import 'package:ap_assistant/apis/people_api.dart';

class Person {
  final String id;
  final Face face;
  final String name;
  final String relation;
  final String patientId;

  Person({
    required this.id,
    required this.face,
    required this.name,
    required this.relation,
    required this.patientId,
  });

  Person copyWith({
    String? id,
    Face? face,
    String? name,
    String? relation,
    String? patientId,
  }) {
    return Person(
      id: id ?? this.id,
      face: face ?? this.face,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      patientId: patientId ?? this.patientId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'face': face.toMap(),
      'relation': relation,
      'patientId': patientId,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      relation: map['relation'],
      patientId: map['patientId'],
      face: Face.fromMap(map['face']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) => Person.fromMap(json.decode(source));
}

class Face {
  final String? leftUrl;
  final String? rightUrl;
  final String? frontUrl;
  final Uint8List? frontBytes;
  final Uint8List? leftBytes;
  final Uint8List? rightBytes;

  String? get fullLeftUrl => leftUrl == null ? null : Uri.http(PeopleApi.baseUrl, leftUrl!).toString();
  String? get fullRightUrl => rightUrl == null ? null : Uri.http(PeopleApi.baseUrl, rightUrl!).toString();
  String? get fullFrontUrl => frontUrl == null ? null : Uri.http(PeopleApi.baseUrl, frontUrl!).toString();

  Face({
    this.leftUrl,
    this.rightUrl,
    this.frontUrl,
    this.leftBytes,
    this.rightBytes,
    this.frontBytes,
  });

  Face copyWith({String? front, String? left, String? right}) {
    return Face(frontUrl: front ?? frontUrl, leftUrl: left ?? leftUrl, rightUrl: right ?? rightUrl);
  }

  Map<String, dynamic> toMap() {
    return {'front': frontUrl, 'left': leftUrl, 'right': rightUrl};
  }

  factory Face.fromMap(Map<String, dynamic> map) {
    return Face(frontUrl: map['front'], leftUrl: map['left'], rightUrl: map['right']);
  }

  String toJson() => json.encode(toMap());

  factory Face.fromJson(String source) => Face.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum FaceDirection { front, left, right }
