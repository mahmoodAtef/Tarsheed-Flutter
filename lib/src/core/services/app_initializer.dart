import 'package:flutter/services.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/local/secure_storage_helper.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';

class AppInitializer {
  static Future<void> init() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await CacheHelper.init();
    await LocalizationManager.init();
    ServiceLocator.init();
    SecureStorageHelper.init();
    DioHelper.init();
    await _getSavedData();
  }

  static Future<void> _getSavedData() async {
    Future.wait([
      SecureStorageHelper.getData(key: "id"),
      SecureStorageHelper.getData(key: "token")
    ]).then((value) {
      ApiManager.userId = value[0];
      ApiManager.authToken = value[1];
    });
  }
}
