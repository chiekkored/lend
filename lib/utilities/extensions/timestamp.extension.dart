import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

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

  String toTimeAgo({bool forceAgo = false}) {
    if (this == null) return 'DateTime is null';
    if (DateTime.now().difference(this!.toDate()).inMinutes > 59 && !forceAgo) {
      return toFormattedStringTimeOnly();
    }
    return timeago.format(this!.toDate(), locale: 'en_short');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_seconds': this!.seconds,
      '_nanoseconds': this!.nanoseconds,
    };
  }
}
