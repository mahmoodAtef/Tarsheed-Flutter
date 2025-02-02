import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/local/secure_storage_helper.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';

class AppInitializer {
  static Future<void> init() async {
    ServiceLocator.init();
    await CacheHelper.init();
    //  Future.wait([ , LocalizationManager.init(), ]);
    SecureStorageHelper.init();
    DioHelper.init();
  }
}
