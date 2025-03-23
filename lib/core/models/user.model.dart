// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? address;
  String? photoUrl;
  Timestamp? createdAt;
  String? email;
  String? phone;
  String? type;
  bool? verified;
  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.address,
    required this.photoUrl,
    required this.createdAt,
    required this.email,
    required this.phone,
    required this.type,
    required this.verified,
  });

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? address,
    String? photoUrl,
    Timestamp? createdAt,
    String? email,
    String? phone,
    String? type,
    bool? verified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      verified: verified ?? this.verified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'address': address,
      'photoUrl': photoUrl,
      'createdAt':
          createdAt != null
              ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
              : null,
      'email': email,
      'phone': phone,
      'type': type,
      'verified': verified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      dateOfBirth:
          map['dateOfBirth'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int)
              : null,
      address: map['address'] != null ? map['address'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      verified: map['verified'] != null ? map['verified'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, address: $address, photoUrl: $photoUrl, createdAt: $createdAt, email: $email, phone: $phone, type: $type, verified: $verified)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.dateOfBirth == dateOfBirth &&
        other.address == address &&
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt &&
        other.email == email &&
        other.phone == phone &&
        other.type == type &&
        other.verified == verified;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        dateOfBirth.hashCode ^
        address.hashCode ^
        photoUrl.hashCode ^
        createdAt.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        type.hashCode ^
        verified.hashCode;
  }
}
