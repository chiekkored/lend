// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lend/utilities/extensions/geopoint.extension.dart';

class Location {
  String? description;
  String? country;
  String? cityState;
  GeoPoint? latLng;
  bool? useSpecificLocation;
  Location({
    this.description,
    this.country,
    this.cityState,
    this.latLng,
    this.useSpecificLocation,
  });

  Location copyWith({
    String? description,
    String? country,
    String? cityState,
    GeoPoint? latLng,
    bool? useSpecificLocation,
  }) {
    return Location(
      description: description ?? this.description,
      country: country ?? this.country,
      cityState: cityState ?? this.cityState,
      latLng: latLng ?? this.latLng,
      useSpecificLocation: useSpecificLocation ?? this.useSpecificLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'country': country,
      'cityState': cityState,
      'latLng': latLng?.toMap(),
      'useSpecificLocation': useSpecificLocation,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      description:
          map['description'] != null ? map['description'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      cityState: map['cityState'] != null ? map['cityState'] as String : null,
      latLng:
          map['latLng'] != null
              ? map['latLng'] is GeoPoint
                  ? map['latLng'] as GeoPoint
                  : GeoPoint(
                    map['latLng']['latitude'],
                    map['latLng']['longitude'],
                  )
              : null,
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
      'Location(description: $description,country: $country,cityState: $cityState, latLng: $latLng), useSpecificLocation: $useSpecificLocation)';

  @override
  bool operator ==(covariant Object other) {
    if (identical(this, other)) return true;
    if (other is! Location) return false;

    return other.description == description &&
        other.country == country &&
        other.cityState == cityState &&
        other.latLng == latLng &&
        other.useSpecificLocation == useSpecificLocation;
  }

  @override
  int get hashCode =>
      description.hashCode ^
      country.hashCode ^
      cityState.hashCode ^
      latLng.hashCode ^
      useSpecificLocation.hashCode;
}
