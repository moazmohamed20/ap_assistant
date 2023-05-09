import 'dart:convert';

class Location {
  final String id;
  final double latitude;
  final double longitude;
  final DateTime time;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.time,
  });

  Location copyWith({
    String? id,
    double? latitude,
    double? longitude,
    DateTime? time,
  }) {
    return Location(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'time': time.toIso8601String(),
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      time: DateTime.parse(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source) as Map<String, dynamic>);
}
