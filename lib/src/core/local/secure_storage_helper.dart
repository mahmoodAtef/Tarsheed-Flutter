import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static late FlutterSecureStorage secureStorage;

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

  static Future<void> saveData({
    required String key,
    required dynamic value,
    Duration? expiresAfter,
  }) async {
    await secureStorage.delete(key: key);
    if (expiresAfter != null) {
      final DateTime expiresAt = DateTime.now().add(expiresAfter);
      final String dataToStore = jsonEncode({
        'value': value.toString(),
        'expiresAt': expiresAt.millisecondsSinceEpoch,
      });
      await secureStorage.write(key: key, value: dataToStore);
    } else {
      await secureStorage.write(key: key, value: value.toString());
    }
  }

  static Future<String?> getData({required String key}) async {
    final String? data = await secureStorage.read(key: key);
    if (data == null) return null;
    try {
      final Map<String, dynamic> jsonData = jsonDecode(data);
      if (jsonData.containsKey('expiresAt') && jsonData.containsKey('value')) {
        final int expiresAtMillis = jsonData['expiresAt'] as int;
        final DateTime expiresAt =
            DateTime.fromMillisecondsSinceEpoch(expiresAtMillis);
        if (DateTime.now().isAfter(expiresAt)) {
          await secureStorage.delete(key: key);
          return null;
        } else {
          return jsonData['value'].toString();
        }
      }
      return data;
    } catch (e) {
      return data;
    }
  }

  static Future<void> removeData({required String key}) async {
    await secureStorage.delete(key: key);
  }

  static Future<void> clearAll() async {
    await secureStorage.deleteAll();
  }
}
