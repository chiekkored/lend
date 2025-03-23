import 'package:intl/intl.dart';

extension StringFormatter on String {
  DateTime toFormattedDateTime() {
    return DateFormat('MMMM dd, yyyy').parse(this);
  }
}
