// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? uid;
  String? name;
  String? address;
  String? photoUrl;
  Timestamp? createdAt;
  String? email;
  String? phone;
  String? type;
  bool? verified;
  User({
    this.uid,
    this.name,
    this.address,
    this.photoUrl,
    this.createdAt,
    this.email,
    this.phone,
    this.type,
    this.verified,
  });

  User copyWith({
    String? uid,
    String? name,
    String? address,
    String? photoUrl,
    Timestamp? createdAt,
    String? email,
    String? phone,
    String? type,
    bool? verified,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
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
      'name': name,
      'address': address,
      'photoUrl': photoUrl,
      'createdAt': createdAt != null
          ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
          : null,
      'email': email,
      'phone': phone,
      'type': type,
      'verified': verified,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
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

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, address: $address, photoUrl: $photoUrl, createdAt: $createdAt, email: $email, phone: $phone, type: $type, verified: $verified)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
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
        name.hashCode ^
        address.hashCode ^
        photoUrl.hashCode ^
        createdAt.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        type.hashCode ^
        verified.hashCode;
  }
}
