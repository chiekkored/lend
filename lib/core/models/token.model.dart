// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Token {
  final String? handoverToken;
  final String? returnToken;
  final Timestamp? handoverExpiry;
  final Timestamp? returnExpiry;
  Token({
    this.handoverToken,
    this.returnToken,
    this.handoverExpiry,
    this.returnExpiry,
  });

  Token copyWith({
    String? handoverToken,
    String? returnToken,
    Timestamp? handoverExpiry,
    Timestamp? returnExpiry,
  }) {
    return Token(
      handoverToken: handoverToken ?? this.handoverToken,
      returnToken: returnToken ?? this.returnToken,
      handoverExpiry: handoverExpiry ?? this.handoverExpiry,
      returnExpiry: returnExpiry ?? this.returnExpiry,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'handoverToken': handoverToken,
      'returnToken': returnToken,
      'handoverExpiry':
          handoverExpiry != null
              ? Timestamp(handoverExpiry!.seconds, handoverExpiry!.nanoseconds)
              : null,
      'returnExpiry':
          returnExpiry != null
              ? Timestamp(returnExpiry!.seconds, returnExpiry!.nanoseconds)
              : null,
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      handoverToken:
          map['handoverToken'] != null ? map['handoverToken'] as String : null,
      returnToken:
          map['returnToken'] != null ? map['returnToken'] as String : null,
      handoverExpiry:
          map['handoverExpiry'] != null
              ? map['handoverExpiry'] is Timestamp
                  ? map['handoverExpiry'] as Timestamp
                  : Timestamp(
                    map['handoverExpiry']['_seconds'],
                    map['handoverExpiry']['_nanoseconds'],
                  )
              : null,
      returnExpiry:
          map['returnExpiry'] != null
              ? map['returnExpiry'] is Timestamp
                  ? map['returnExpiry'] as Timestamp
                  : Timestamp(
                    map['returnExpiry']['_seconds'],
                    map['returnExpiry']['_nanoseconds'],
                  )
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Token.fromJson(String source) =>
      Token.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Token(handoverToken: $handoverToken, returnToken: $returnToken, handoverExpiry: $handoverExpiry, returnExpiry: $returnExpiry)';
  }

  @override
  bool operator ==(covariant Token other) {
    if (identical(this, other)) return true;

    return other.handoverToken == handoverToken &&
        other.returnToken == returnToken &&
        other.handoverExpiry == handoverExpiry &&
        other.returnExpiry == returnExpiry;
  }

  @override
  int get hashCode {
    return handoverToken.hashCode ^
        returnToken.hashCode ^
        handoverExpiry.hashCode ^
        returnExpiry.hashCode;
  }
}
