import 'package:intl/intl.dart';

extension DateFormatter on DateTime? {
  /// Example: `March 23, 2025`
  String toMonthDayYear() {
    if (this == null) return 'DateTime is null';
    return DateFormat('MMMM dd, yyyy').format(this!);
  }

  /// Example: `Mar 23, 2025`
  String toAbbrMonthDayYear() {
    if (this == null) return 'DateTime is null';
    return DateFormat('MMM dd, yyyy').format(this!);
  }

  /// Example: `Mar 23, 2025`
  String toAbbrMonth() {
    if (this == null) return 'DateTime is null';
    return DateFormat('MMM').format(this!);
  }

  /// Example: `23/03/2025`
  String toDayMonthYear() {
    if (this == null) return 'DateTime is null';
    return DateFormat('dd/MM/yyyy').format(this!);
  }

  /// Example: `Sunday, March 23, 2025`
  String toWeekdayMonthDayYear() {
    if (this == null) return 'DateTime is null';
    return DateFormat('EEEE, MMMM dd, yyyy').format(this!);
  }

  /// Example: `10:55 PM`
  String toHourMinuteAmPm() {
    if (this == null) return 'DateTime is null';
    return DateFormat('h:mm a').format(this!);
  }

  /// Example: `22:55:35`
  String toHourMinuteSecond24Hour() {
    if (this == null) return 'DateTime is null';
    return DateFormat('HH:mm:ss').format(this!);
  }

  /// Example: `Sun, Mar 23, 2025`
  String toAbbrWeekdayMonthDayYear() {
    if (this == null) return 'DateTime is null';
    return DateFormat('EEE, MMM dd, yyyy').format(this!);
  }

  /// Example: `2025-03-23`
  String toYearMonthDay() {
    if (this == null) return 'DateTime is null';
    return DateFormat('yyyy-MM-dd').format(this!);
  }

  /// Example: `Q1 2025`
  String toQuarterYear() {
    if (this == null) return 'DateTime is null';
    return DateFormat('QQQ yyyy').format(this!);
  }
}

extension StringFormatter on String {
  /// Converts a string to a String with comma
  String toMoney() {
    // Check if the string is a number
    if (double.tryParse(this) == null) {
      return this;
    }
    // Add commas to the number
    final numberParts = split('.');
    final formattedNumber = numberParts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
    final formattedText =
        numberParts.length > 1
            ? '$formattedNumber.${numberParts[1]}'
            : formattedNumber;
    return formattedText;
  }

  String toNumber() {
    // Check if the string is a number
    if (double.tryParse(this) != null) {
      return this;
    }

    // Remove commas from the string
    final number = replaceAll(',', '');
    return number;
  }
}
