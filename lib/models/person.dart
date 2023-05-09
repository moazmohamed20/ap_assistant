import 'dart:convert';
import 'dart:typed_data';

class Person {
  final String name;
  final String relation;
  final List<String> imagesUrls;
  final List<Uint8List?> imagesBytes;

  Person({
    required this.name,
    required this.relation,
    this.imagesUrls = const [],
    this.imagesBytes = const [],
  });

  Person copyWith({
    String? name,
    String? relation,
    List<String>? imagesUrls,
    List<Uint8List>? imagesBytes,
  }) {
    return Person(
      name: name ?? this.name,
      relation: relation ?? this.relation,
      imagesUrls: imagesUrls ?? this.imagesUrls,
      imagesBytes: imagesBytes ?? this.imagesBytes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'relation': relation,
      'imagesUrls': imagesUrls,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'],
      relation: map['relation'],
      imagesUrls: List<String>.from((map['imagesUrls'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) => Person.fromMap(json.decode(source));
}
