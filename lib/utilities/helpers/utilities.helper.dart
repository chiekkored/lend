import 'package:lend/utilities/extensions/string.extension.dart';

class LNDUtils {
  static String formatFullName({
    required String? firstName,
    required String? lastName,
  }) {
    if (firstName == null || lastName == null) return 'No name';
    return '$firstName $lastName';
  }

  static String getDateRange({
    required DateTime? start,
    required DateTime? end,
  }) {
    if (start == null || end == null) return '';

    String startMonth = start.toAbbrMonth();
    String endMonth = end.toAbbrMonth();

    if (startMonth == endMonth) {
      return '$startMonth ${start.day} - ${end.day}, ${end.year}';
    } else {
      return '$startMonth ${start.day} - $endMonth ${end.day}, ${end.year}';
    }
  }
}
