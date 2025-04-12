// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String? description;
  GeoPoint? latLng;
  bool? useSpecificLocation;
  Location({this.description, this.latLng, this.useSpecificLocation});

  Location copyWith({
    String? description,
    GeoPoint? latLng,
    bool? useSpecificLocation,
  }) {
    return Location(
      description: description ?? this.description,
      latLng: latLng ?? this.latLng,
      useSpecificLocation: useSpecificLocation ?? this.useSpecificLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'latLng':
          latLng != null ? GeoPoint(latLng!.latitude, latLng!.longitude) : null,
      'useSpecificLocation': useSpecificLocation,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      description:
          map['description'] != null ? map['description'] as String : null,
      latLng: map['latLng'] != null ? map['latLng'] as GeoPoint : null,
      useSpecificLocation:
          map['useSpecificLocation'] != null
              ? map['useSpecificLocation'] as bool
              : true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Location(description: $description, latLng: $latLng), useSpecificLocation: $useSpecificLocation)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;

    return other.description == description &&
        other.latLng == latLng &&
        other.useSpecificLocation == useSpecificLocation;
  }

  @override
  int get hashCode =>
      description.hashCode ^ latLng.hashCode ^ useSpecificLocation.hashCode;
}
