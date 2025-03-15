import 'package:intl/intl.dart';

extension StringConversions on int {
  /// Remove decimal if number is whole number.
  /// If number has decimal, fix decimal point to one.
  String toMoney() => NumberFormat('#,###').format(this);
}
