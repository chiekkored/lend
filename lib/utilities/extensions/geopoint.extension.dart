import 'package:cloud_firestore/cloud_firestore.dart';

extension GeoPointFormatter on GeoPoint? {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': this!.latitude,
      'longitude': this!.longitude,
    };
  }
}
