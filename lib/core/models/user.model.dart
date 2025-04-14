// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lend/core/models/location.model.dart';

import 'package:lend/utilities/enums/eligibility.enum.dart';

class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  Location? location;
  String? photoUrl;
  Timestamp? createdAt;
  String? email;
  String? phone;
  String? type;
  Eligibility? isListingEligible;
  Eligibility? isRentingEligible;
  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.location,
    required this.photoUrl,
    required this.createdAt,
    required this.email,
    required this.phone,
    required this.type,
    required this.isListingEligible,
    required this.isRentingEligible,
  });

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    Location? location,
    String? photoUrl,
    Timestamp? createdAt,
    String? email,
    String? phone,
    String? type,
    Eligibility? isListingEligible,
    Eligibility? isRentingEligible,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      isListingEligible: isListingEligible ?? this.isListingEligible,
      isRentingEligible: isRentingEligible ?? this.isRentingEligible,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'location': location,
      'photoUrl': photoUrl,
      'createdAt':
          createdAt != null
              ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
              : null,
      'email': email,
      'phone': phone,
      'type': type,
      'isListingEligible': isListingEligible?.label,
      'isRentingEligible': isRentingEligible?.label,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      dateOfBirth:
          map['dateOfBirth'] != null
              ? (map['dateOfBirth'] as Timestamp).toDate()
              : null,
      location:
          map['location'] != null
              ? Location.fromMap(map['location'] as Map<String, dynamic>)
              : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      isListingEligible: Eligibility.values.firstWhere(
        (element) => element.label == map['isListingEligible'],
        orElse: () => Eligibility.no,
      ),
      isRentingEligible: Eligibility.values.firstWhere(
        (element) => element.label == map['isRentingEligible'],
        orElse: () => Eligibility.no,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, location: $location, photoUrl: $photoUrl, createdAt: $createdAt, email: $email, phone: $phone, type: $type, isListingEligible: $isListingEligible, isRentingEligible: $isRentingEligible)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.dateOfBirth == dateOfBirth &&
        other.location == location &&
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt &&
        other.email == email &&
        other.phone == phone &&
        other.type == type &&
        other.isListingEligible == isListingEligible &&
        other.isRentingEligible == isRentingEligible;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        dateOfBirth.hashCode ^
        location.hashCode ^
        photoUrl.hashCode ^
        createdAt.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        type.hashCode ^
        isListingEligible.hashCode ^
        isRentingEligible.hashCode;
  }
}
