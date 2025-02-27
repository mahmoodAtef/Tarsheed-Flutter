import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/local/secure_storage_helper.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';

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
    var authData = await SecureStorageHelper.getData(key: "auth_info");
    if (authData != null) {
      AuthInfo authInfo = AuthInfo.fromJson(jsonDecode(authData));
      ApiManager.authToken = authInfo.accessToken;
      ApiManager.userId = authInfo.userId;
    }
  }
}
