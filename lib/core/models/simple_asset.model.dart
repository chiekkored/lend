// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/models/location.model.dart';

class SimpleAsset {
  final String id;
  final String? ownerId;
  final String? title;
  final List<String>? images;
  final List<Booking>? bookings;
  final String? category;
  final Timestamp? createdAt;
  final String? status;
  final Location? location;
  SimpleAsset({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.images,
    this.bookings,
    required this.category,
    required this.createdAt,
    required this.status,
    required this.location,
  });

  // SimpleAsset copyWith({
  //   String? id,
  //   String? ownerId,
  //   String? title,
  //   List<String>? images,
  //   List<Booking>? bookings,
  //   String? category,
  //   Timestamp? createdAt,
  //   String? status,
  // }) {
  //   return SimpleAsset(
  //     id: id ?? this.id,
  //     ownerId: ownerId ?? this.ownerId,
  //     title: title ?? this.title,
  //     images: images ?? this.images,
  //     bookings: bookings ?? this.bookings,
  //     category: category ?? this.category,
  //     createdAt: createdAt ?? this.createdAt,
  //     status: status ?? this.status,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'title': title,
      'images': images,

      'bookings': bookings?.map((x) => x.toMap()).toList(),
      'category': category,
      'createdAt':
          createdAt != null
              ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
              : null,
      'status': status,
      'location': location?.toMap(),
    };
  }

  factory SimpleAsset.fromMap(Map<String, dynamic> map) {
    return SimpleAsset(
      id: map['id'] as String,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      images: map['images'] != null ? List<String>.from((map['images'])) : null,
      bookings:
          map['bookings'] != null ? List<Booking>.from(map['bookings']) : null,
      category: map['category'] != null ? map['category'] as String : null,
      createdAt:
          map['createdAt'] != null
              ? map['createdAt'] is Timestamp
                  ? map['createdAt'] as Timestamp
                  : Timestamp(
                    map['createdAt']['_seconds'],
                    map['createdAt']['_nanoseconds'],
                  )
              : null,
      status: map['status'] != null ? map['status'] as String : null,
      location: Location.fromMap(map['location'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SimpleAsset.fromJson(String source) =>
      SimpleAsset.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SimpleAsset(id: $id, ownerId: $ownerId, title: $title, images: $images, bookings: $bookings, category: $category, createdAt: $createdAt, status: $status, location: $location)';
  }

  @override
  bool operator ==(covariant SimpleAsset other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerId == ownerId &&
        other.title == title &&
        listEquals(other.images, images) &&
        listEquals(other.bookings, bookings) &&
        other.category == category &&
        other.createdAt == createdAt &&
        other.status == status &&
        other.location == location;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        title.hashCode ^
        images.hashCode ^
        bookings.hashCode ^
        category.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        location.hashCode;
  }
}

class AddSimpleAsset {
  final String id;
  final String? ownerId;
  final String? title;
  final List<String>? images;
  final String? category;
  final Timestamp? createdAt;
  final String? status;
  AddSimpleAsset({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.images,
    required this.category,
    required this.createdAt,
    required this.status,
  });

  AddSimpleAsset copyWith({
    String? id,
    String? ownerId,
    String? title,
    List<String>? images,
    String? category,
    Timestamp? createdAt,
    String? status,
  }) {
    return AddSimpleAsset(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      images: images ?? this.images,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'title': title,
      'images': images,
      'category': category,
      'createdAt':
          createdAt != null
              ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
              : null,
      'status': status,
    };
  }

  factory AddSimpleAsset.fromMap(Map<String, dynamic> map) {
    return AddSimpleAsset(
      id: map['id'] as String,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      images: map['images'] != null ? List<String>.from((map['images'])) : null,
      category: map['category'] != null ? map['category'] as String : null,
      createdAt:
          map['createdAt'] != null
              ? map['createdAt'] is Timestamp
                  ? map['createdAt'] as Timestamp
                  : Timestamp(
                    map['createdAt']['_seconds'],
                    map['createdAt']['_nanoseconds'],
                  )
              : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddSimpleAsset.fromJson(String source) =>
      AddSimpleAsset.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddSimpleAsset(id: $id, ownerId: $ownerId, title: $title, images: $images, category: $category, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(covariant AddSimpleAsset other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerId == ownerId &&
        other.title == title &&
        listEquals(other.images, images) &&
        other.category == category &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        title.hashCode ^
        images.hashCode ^
        category.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }
}
