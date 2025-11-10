// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lend/utilities/extensions/timestamp.extension.dart';

class BookingAction {
  final bool? status;
  final Timestamp? updatedAt;
  final String? verifiedBy;
  BookingAction({this.status, this.updatedAt, this.verifiedBy});

  BookingAction copyWith({
    bool? status,
    Timestamp? updatedAt,
    String? verifiedBy,
  }) {
    return BookingAction(
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'updatedAt': updatedAt?.toMap(),
      'verifiedBy': verifiedBy,
    };
  }

  factory BookingAction.fromMap(Map<String, dynamic> map) {
    return BookingAction(
      status: map['status'] != null ? map['status'] as bool : null,
      updatedAt:
          map['updatedAt'] != null
              ? map['updatedAt'] is Timestamp
                  ? map['updatedAt'] as Timestamp
                  : Timestamp(
                    map['updatedAt']['_seconds'],
                    map['updatedAt']['_nanoseconds'],
                  )
              : null,
      verifiedBy:
          map['verifiedBy'] != null ? map['verifiedBy'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingAction.fromJson(String source) =>
      BookingAction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BookingAction(status: $status, updatedAt: $updatedAt, verifiedBy: $verifiedBy)';

  @override
  bool operator ==(covariant BookingAction other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.updatedAt == updatedAt &&
        other.verifiedBy == verifiedBy;
  }

  @override
  int get hashCode =>
      status.hashCode ^ updatedAt.hashCode ^ verifiedBy.hashCode;
}
