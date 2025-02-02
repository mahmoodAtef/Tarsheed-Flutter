import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/local/secure_storage_helper.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';

class AppInitializer {
  Future<void> init() async {
    ServiceLocator.init();
    Future.wait([LocalizationManager.init(), CacheHelper.init()]);
    SecureStorageHelper.init();
    DioHelper.init();
  }
}
