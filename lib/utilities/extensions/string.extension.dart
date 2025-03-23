import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  /// Example: `March 23, 2025`
  String toMonthDayYear() {
    return DateFormat('MMMM dd, yyyy').format(this);
  }

  /// Example: `Mar 23, 2025`
  String toAbbrMonthDayYear() {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Example: `Mar 23, 2025`
  String toAbbrMonth() {
    return DateFormat('MMM').format(this);
  }

  /// Example: `23/03/2025`
  String toDayMonthYear() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Example: `Sunday, March 23, 2025`
  String toWeekdayMonthDayYear() {
    return DateFormat('EEEE, MMMM dd, yyyy').format(this);
  }

  /// Example: `10:55 PM`
  String toHourMinuteAmPm() {
    return DateFormat('h:mm a').format(this);
  }

  /// Example: `22:55:35`
  String toHourMinuteSecond24Hour() {
    return DateFormat('HH:mm:ss').format(this);
  }

  /// Example: `Sun, Mar 23, 2025`
  String toAbbrWeekdayMonthDayYear() {
    return DateFormat('EEE, MMM dd, yyyy').format(this);
  }

  /// Example: `2025-03-23`
  String toYearMonthDay() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Example: `Q1 2025`
  String toQuarterYear() {
    return DateFormat('QQQ yyyy').format(this);
  }
}
