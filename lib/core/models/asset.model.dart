// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lend/core/models/rates.model.dart';

class Asset {
  String id;
  String? ownerId;
  String? title;
  String? description;
  String? category;
  Rates? rates;
  List<Timestamp>? availability;
  GeoPoint? location;
  List<String>? images;
  List<String>? showcase;
  List<String>? inclusions;
  Timestamp? createdAt;
  String? status;
  Asset({
    required this.id,
    this.ownerId,
    this.title,
    this.description,
    this.category,
    this.rates,
    this.availability,
    this.location,
    this.images,
    this.showcase,
    this.inclusions,
    this.createdAt,
    this.status,
  });

  Asset copyWith({
    required String id,
    String? ownerId,
    String? title,
    String? description,
    String? category,
    Rates? rates,
    List<Timestamp>? availability,
    GeoPoint? location,
    List<String>? images,
    List<String>? showcase,
    List<String>? inclusions,
    Timestamp? createdAt,
    String? status,
  }) {
    return Asset(
      id: id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      rates: rates ?? this.rates,
      availability: availability ?? this.availability,
      location: location ?? this.location,
      images: images ?? this.images,
      showcase: showcase ?? this.showcase,
      inclusions: inclusions ?? this.inclusions,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'category': category,
      'rates': rates?.toMap(),
      'availability':
          availability?.map((x) => Timestamp(x.seconds, x.nanoseconds)),
      'location': location != null
          ? GeoPoint(location!.latitude, location!.longitude)
          : null,
      'images': images,
      'showcase': showcase,
      'inclusions': inclusions,
      'createdAt': createdAt != null
          ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
          : null,
      'status': status,
    };
  }

  factory Asset.fromMap(Map<String, dynamic> map, String id) {
    return Asset(
      id: id,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      rates: map['rates'] != null
          ? Rates.fromMap(map['rates'] as Map<String, dynamic>)
          : null,
      availability: map['availability'] != null
          ? List<Timestamp>.from(map['availability'])
          : null,
      location: map['location'] != null ? map['location'] as GeoPoint : null,
      images: map['images'] != null ? List<String>.from((map['images'])) : null,
      showcase:
          map['showcase'] != null ? List<String>.from((map['showcase'])) : null,
      inclusions: map['inclusions'] != null
          ? List<String>.from((map['inclusions']))
          : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Asset.fromJson(String source, String id) =>
      Asset.fromMap(json.decode(source) as Map<String, dynamic>, id);

  @override
  String toString() {
    return 'Asset(id: $id, ownerId: $ownerId, title: $title, description: $description, category: $category, rates: $rates, availability: $availability, location: $location, images: $images, showcase: $showcase, inclusions: $inclusions, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(covariant Asset other) {
    if (identical(this, other)) return true;

    return other.ownerId == ownerId &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.rates == rates &&
        listEquals(other.availability, availability) &&
        other.location == location &&
        listEquals(other.images, images) &&
        listEquals(other.showcase, showcase) &&
        listEquals(other.inclusions, inclusions) &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        rates.hashCode ^
        availability.hashCode ^
        location.hashCode ^
        images.hashCode ^
        showcase.hashCode ^
        inclusions.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }
}
