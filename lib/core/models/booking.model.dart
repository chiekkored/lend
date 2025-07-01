// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:lend/core/models/simple_asset.model.dart';

class Booking {
  String? id;
  SimpleAsset? asset;
  Timestamp? createdAt;
  Payment? payment;
  String? renterId;
  String? status;
  int? totalPrice;
  List<Timestamp>? dates;
  Booking({
    required this.id,
    required this.asset,
    required this.createdAt,
    required this.payment,
    required this.renterId,
    required this.status,
    required this.totalPrice,
    required this.dates,
  });

  Booking copyWith({
    String? id,
    SimpleAsset? asset,
    Timestamp? createdAt,
    Payment? payment,
    String? renterId,
    String? status,
    int? totalPrice,
    List<Timestamp>? dates,
  }) {
    return Booking(
      id: id ?? this.id,
      asset: asset ?? this.asset,
      createdAt: createdAt ?? this.createdAt,
      payment: payment ?? this.payment,
      renterId: renterId ?? this.renterId,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      dates: dates ?? this.dates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'asset': asset?.toMap(),
      'createdAt':
          createdAt != null
              ? Timestamp(createdAt!.seconds, createdAt!.nanoseconds)
              : null,
      'payment': payment?.toMap(),
      'renterId': renterId,
      'status': status,
      'totalPrice': totalPrice,
      'dates': dates?.map((x) => Timestamp(x.seconds, x.nanoseconds)).toList(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] != null ? map['id'] as String : null,
      asset:
          map['asset'] != null
              ? SimpleAsset.fromMap(map['asset'] as Map<String, dynamic>)
              : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      payment:
          map['payment'] != null
              ? Payment.fromMap(map['payment'] as Map<String, dynamic>)
              : null,
      renterId: map['renterId'] != null ? map['renterId'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      totalPrice: map['totalPrice'] != null ? map['totalPrice'] as int : null,
      dates: map['dates'] != null ? List<Timestamp>.from(map['dates']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) =>
      Booking.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Booking(id: $id, asset: $asset, createdAt: $createdAt, payment: $payment, renterId: $renterId, status: $status, totalPrice: $totalPrice, dates: $dates)';
  }

  @override
  bool operator ==(covariant Booking other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.asset == asset &&
        other.createdAt == createdAt &&
        other.payment == payment &&
        other.renterId == renterId &&
        other.status == status &&
        other.totalPrice == totalPrice &&
        listEquals(other.dates, dates);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        asset.hashCode ^
        createdAt.hashCode ^
        payment.hashCode ^
        renterId.hashCode ^
        status.hashCode ^
        totalPrice.hashCode ^
        dates.hashCode;
  }
}

class Payment {
  String? method;
  String? transactionId;
  Payment({this.method, this.transactionId});

  Payment copyWith({String? method, String? transactionId}) {
    return Payment(
      method: method ?? this.method,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'method': method, 'transactionId': transactionId};
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      method: map['method'] != null ? map['method'] as String : null,
      transactionId:
          map['transactionId'] != null ? map['transactionId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Payment(method: $method, transactionId: $transactionId)';

  @override
  bool operator ==(covariant Payment other) {
    if (identical(this, other)) return true;

    return other.method == method && other.transactionId == transactionId;
  }

  @override
  int get hashCode => method.hashCode ^ transactionId.hashCode;
}
