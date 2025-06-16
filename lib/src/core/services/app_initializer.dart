import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tarsheed/firebase_options.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/services/secure_storage_helper.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/notifications/data/services/notifications_services.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/main_screen.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/welcome_screen.dart';

class AppInitializer {
  static bool? _isFirstRun;
  static void initializeServiceLocator() {
    ServiceLocator.init();
  }

  static Future<Widget> init() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SecureStorageHelper.init();
    DioHelper.init();
    await _getSavedData();
    if (ApiManager.authToken != null) {
      DioHelper.setToken(ApiManager.authToken!);
    }
    NotificationsRemoteService.initialize();
    return _isFirstRun == true
        ? WelcomeScreen()
        : _isLoggedIn()
            ? MainScreen()
            : LoginPage();
  }

  static bool _isLoggedIn() =>
      ApiManager.userId != null &&
      ApiManager.authToken != null &&
      ApiManager.userId != "null" &&
      ApiManager.authToken != "null";
  static Future<void> _getSavedData() async {
    try {
      var authData = await SecureStorageHelper.getData(key: "auth_info");
      _isFirstRun =
          await SecureStorageHelper.getData(key: "first_run_flag") == null;
      if (authData != null) {
        debugPrint(authData);
        AuthInfo authInfo = AuthInfo.fromJson(jsonDecode(authData));

        ApiManager.authToken = authInfo.accessToken;
        ApiManager.userId = authInfo.userId;
      }
      debugPrint(authData);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> saveFirstRunFlag() async {
    await SecureStorageHelper.saveData(key: "first_run_flag", value: "done");
  }
}
