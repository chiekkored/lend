import 'package:cloud_firestore/cloud_firestore.dart';

extension GeoPointFormatter on GeoPoint? {
  Map<String, dynamic>? toMap() {
    if (this == null) return null;

    return {'latitude': this!.latitude, 'longitude': this!.longitude};
  }
}
