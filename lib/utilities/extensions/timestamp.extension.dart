import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatter on Timestamp? {
  String toFormattedString() {
    if (this == null) {
      return '';
    }
    return DateFormat('MMMM dd, yyyy').format(this!.toDate());
  }

  String toFormattedStringWithTime() {
    if (this == null) {
      return '';
    }
    return DateFormat('MMMM dd, yyyy hh:mm a').format(this!.toDate());
  }

  String toFormattedStringTimeOnly() {
    if (this == null) {
      return '';
    }
    return DateFormat('hh:mm a').format(this!.toDate());
  }
}
