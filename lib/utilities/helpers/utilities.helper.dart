class LNDUtils {
  static final LNDUtils _instance = LNDUtils._internal();

  factory LNDUtils() {
    return _instance;
  }

  LNDUtils._internal();

  static String formatFullName({
    required String? firstName,
    required String? lastName,
  }) {
    if (firstName == null || lastName == null) return 'Setup your name';
    return '$firstName $lastName';
  }
}
