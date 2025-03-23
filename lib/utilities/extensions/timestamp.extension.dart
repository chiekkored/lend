import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatter on Timestamp {
  String toFormattedString() {
    return DateFormat('MMMM dd, yyyy').format(toDate());
  }
}
