import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static late FlutterSecureStorage secureStorage;

  // Create storage instance with encryption
  static init() {
    const AndroidOptions androidOptions = AndroidOptions(
      encryptedSharedPreferences: true,
    );

    const IOSOptions iosOptions = IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    );

    secureStorage = const FlutterSecureStorage(
      aOptions: androidOptions,
      iOptions: iosOptions,
    );
  }

  // Save data with different types
  static Future<void> saveData({required String key, required dynamic value}) async {
    await secureStorage.write(key: key, value: value.toString());
  }

  // Get data
  static Future<String?> getData({required String key}) async {
    return await secureStorage.read(key: key);
  }

  // Remove specific data
  static Future<void> removeData({required String key}) async {
    await secureStorage.delete(key: key);
  }

  // Remove all data
  static Future<void> clearAll() async {
    await secureStorage.deleteAll();
  }
}