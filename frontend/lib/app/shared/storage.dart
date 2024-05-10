import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const tokenStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}
