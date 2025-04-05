// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String? description;
  GeoPoint? latLng;
  Location({this.description, this.latLng});

  Location copyWith({String? description, GeoPoint? latLng}) {
    return Location(
      description: description ?? this.description,
      latLng: latLng ?? this.latLng,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'latLng':
          latLng != null ? GeoPoint(latLng!.latitude, latLng!.longitude) : null,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      description:
          map['description'] != null ? map['description'] as String : null,
      latLng: map['latLng'] != null ? map['latLng'] as GeoPoint : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Location(description: $description, latLng: $latLng)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;

    return other.description == description && other.latLng == latLng;
  }

  @override
  int get hashCode => description.hashCode ^ latLng.hashCode;
}
