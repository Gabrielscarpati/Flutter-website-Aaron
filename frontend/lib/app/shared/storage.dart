import 'dart:html';

class StorageRepositor {
  // static const tokenStorage = FlutterSecureStorage(
  //   aOptions: AndroidOptions(encryptedSharedPreferences: true),
  // );

  static final Storage _localStorage = window.localStorage;

  static Future<void> save({required String key, required String value}) async {
    _localStorage[key] = value;
  }

  static Future<String> getId({required String key}) async =>
      _localStorage[key] ?? '';

  static Future<void> remove({required String key}) async {
    _localStorage.remove(key);
  }
}
