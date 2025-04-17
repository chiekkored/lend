import 'package:intl/intl.dart';

extension StringConversions on int? {
  /// Remove decimal if number is whole number.
  /// If number has decimal, fix decimal point to one.
  String toMoney() => NumberFormat('#,###').format(this);
}

/// Extension on [int] to provide additional functionality
extension IntExtension on int {
  /// Limits the integer value up to a specified maximum value
  /// Returns the lesser of this integer and the provided [max] value
  ///
  /// Example: If a list has 6 items and you call length.upTo(10),
  /// it will return 6, because 6 is less than 10.
  int upTo(int max) => this > max ? max : this;
}
