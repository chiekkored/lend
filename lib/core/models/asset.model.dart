// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:lend/core/models/availability.model.dart';
import 'package:lend/core/models/location.model.dart';
import 'package:lend/core/models/rates.model.dart';
import 'package:lend/core/models/simple_user.model.dart';

class Asset {
  String id;
  String? ownerId;
  SimpleUserModel? owner;
  String? title;
  String? description;
  String? category;
  Rates? rates;
  List<Availability>? availability;
  Location? location;
  List<String>? images;
  List<String>? showcase;
  List<String>? inclusions;
  Timestamp? createdAt;
  String? status;
  Asset({
    required this.id,
    this.ownerId,
    this.owner,
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
    String? id,
    String? ownerId,
    SimpleUserModel? owner,
    String? title,
    String? description,
    String? category,
    Rates? rates,
    List<Availability>? availability,
    Location? location,
    List<String>? images,
    List<String>? showcase,
    List<String>? inclusions,
    Timestamp? createdAt,
    String? status,
  }) {
    return Asset(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      owner: owner ?? this.owner,
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
      'owner': owner?.toMap(),
      'title': title,
      'description': description,
      'category': category,
      'rates': rates?.toMap(),
      'availability': availability?.map((x) => x.toMap()).toList(),
      'location': location?.toMap(),
      'images': images,
      'showcase': showcase,
      'inclusions': inclusions,
      'createdAt':
          createdAt != null
              ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
              : null,
      'status': status,
    }..removeWhere((key, value) => value == null);
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'],
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      owner:
          map['owner'] != null
              ? SimpleUserModel.fromMap(map['owner'] as Map<String, dynamic>)
              : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      rates:
          map['rates'] != null
              ? Rates.fromMap(map['rates'] as Map<String, dynamic>)
              : null,
      availability:
          map['availability'] != null
              ? List<Availability>.from(
                map['availability'].map(
                  (x) => Availability.fromMap(x as Map<String, dynamic>),
                ),
              )
              : null,
      location:
          map['location'] != null
              ? Location.fromMap(map['location'] as Map<String, dynamic>)
              : null,
      images: map['images'] != null ? List<String>.from((map['images'])) : null,
      showcase:
          map['showcase'] != null ? List<String>.from((map['showcase'])) : null,
      inclusions:
          map['inclusions'] != null
              ? List<String>.from((map['inclusions']))
              : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Asset.fromJson(String source) =>
      Asset.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Asset(id: $id, ownerId: $ownerId, owner: $owner, title: $title, description: $description, category: $category, rates: $rates, availability: $availability, location: $location, images: $images, showcase: $showcase, inclusions: $inclusions, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(covariant Asset other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerId == ownerId &&
        other.owner == owner &&
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
        owner.hashCode ^
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

class AddAsset {
  String id;
  String ownerId;
  SimpleUserModel? owner;
  String title;
  String description;
  String category;
  Rates rates;
  Location? location;
  List<String> images;
  List<String> showcase;
  List<String> inclusions;
  Timestamp createdAt;
  String status;
  AddAsset({
    required this.id,
    required this.ownerId,
    required this.owner,
    required this.title,
    required this.description,
    required this.category,
    required this.rates,
    required this.location,
    required this.images,
    required this.showcase,
    required this.inclusions,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'owner': owner?.toMap(),
      'title': title,
      'description': description,
      'category': category,
      'rates': rates.toMap(),
      'location': location?.toMap(),
      'images': images,
      'showcase': showcase,
      'inclusions': inclusions,
      'createdAt': createdAt,
      'status': status,
    };
  }

  factory AddAsset.fromMap(Map<String, dynamic> map) {
    return AddAsset(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      owner: map['owner'] as SimpleUserModel,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      rates: Rates.fromMap(map['rates'] as Map<String, dynamic>),
      location: Location.fromMap(map['location'] as Map<String, dynamic>),
      images: List<String>.from((map['images'] as List<String>)),
      showcase: List<String>.from((map['showcase'] as List<String>)),
      inclusions: List<String>.from((map['inclusions'] as List<String>)),
      createdAt: map['createdAt'] as Timestamp,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddAsset.fromJson(String source) =>
      AddAsset.fromMap(json.decode(source) as Map<String, dynamic>);
}
