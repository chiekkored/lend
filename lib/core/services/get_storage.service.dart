import 'package:get_storage/get_storage.dart';

class LNDStorageService {
  static final GetStorage _box = GetStorage();

  // Write a value
  static Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  // Write a list value
  static Future<void> writeList(String key, List<dynamic> value) async {
    await _box.write(key, value);
  }

  // Read a value
  static T? read<T>(String key) {
    return _box.read<T>(key);
  }

  // Read list value
  static List<dynamic>? readList(String key) {
    return _box.read<List<dynamic>>(key);
  }

  // Remove a value
  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  // Listen to changes
  static void listen(void Function() callback) {
    _box.listen(callback);
  }

  // Listen to changes on a specific key
  static void listenKey(String key, void Function(dynamic) callback) {
    _box.listenKey(key, callback);
  }

  // Clear all stored data
  static Future<void> clear() async {
    await _box.erase();
  }
}
