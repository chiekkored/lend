import 'package:lend/core/services/get_storage.service.dart';

class LNDStorageConstants {
  static String assets = 'assets';

  /// Clears all the keys inside the array list
  static Future<void> clear() async {
    for (var key in []) {
      await LNDStorageService.remove(key);
    }
  }
}
