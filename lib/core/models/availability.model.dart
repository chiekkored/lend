// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Availability {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final Timestamp date;
  Availability({
    required this.date,
    this.userId,
    this.firstName,
    this.lastName,
  });

  Availability copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    Timestamp? date,
  }) {
    return Availability(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'date': Timestamp(date.seconds, date.nanoseconds),
    };
  }

  factory Availability.fromMap(Map<String, dynamic> map) {
    return Availability(
      userId: map['userId'] != null ? map['userId'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      date: map['date'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory Availability.fromJson(String source) =>
      Availability.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Availability(userId: $userId, firstName: $firstName, lastName: $lastName, date: $date)';
  }

  @override
  bool operator ==(covariant Availability other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.date == date;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        date.hashCode;
  }
}
