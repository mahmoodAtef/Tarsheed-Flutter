import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/local/secure_storage_helper.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';

class AppInitializer {
  static Future<void> init() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await CacheHelper.init();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory:
          HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );
    ServiceLocator.init();
    SecureStorageHelper.init();
    DioHelper.init();
    await _getSavedData();
  }

  static Future<void> _getSavedData() async {
    var authData = await SecureStorageHelper.getData(key: "auth_info");
    // if (authData != null) {
    //   AuthInfo authInfo =
    //       AuthInfo.fromJson(await jsonDecode(authData.toString()));
    //   ApiManager.authToken = authInfo.accessToken;
    //   ApiManager.userId = authInfo.userId;
    // }
    debugPrint(authData);
  }
}
