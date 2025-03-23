// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/booking.model.dart';

class Rental {
  final Booking booking;
  final Asset asset;
  Rental({required this.booking, required this.asset});

  Rental copyWith({Booking? booking, Asset? asset}) {
    return Rental(booking: booking ?? this.booking, asset: asset ?? this.asset);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'booking': booking.toMap(),
      'asset': asset.toMap(),
    };
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
      booking: Booking.fromMap(map['booking'] as Map<String, dynamic>),
      asset: Asset.fromMap(map['asset'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Rental.fromJson(String source) =>
      Rental.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Rental(booking: $booking, asset: $asset)';

  @override
  bool operator ==(covariant Rental other) {
    if (identical(this, other)) return true;

    return other.booking == booking && other.asset == asset;
  }

  @override
  int get hashCode => booking.hashCode ^ asset.hashCode;
}
