import 'package:get_it/get_it.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_local_services.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';
import 'package:tarsheed/src/modules/settings/data/services/settings_local_services.dart';
import 'package:tarsheed/src/modules/settings/data/services/settings_remote_services.dart';

import '../../modules/settings/data/repositories/settings_repository.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    AuthRemoteServices authRemoteServices = AuthRemoteServices();
    AuthLocalServices authLocalServices = AuthLocalServices();
    sl.registerLazySingleton(() => authRemoteServices);
    AuthRepository authRepository =
        AuthRepository(authRemoteServices, authLocalServices);
    sl.registerLazySingleton(() => authRepository);

    SettingsRemoteServices settingsRemoteServices = SettingsRemoteServices();
    SettingsLocalServices settingsLocalServices = SettingsLocalServices();
    sl.registerLazySingleton(() => settingsRemoteServices);
    SettingsRepository settingsRepository =
        SettingsRepository(settingsRemoteServices, settingsLocalServices);
    sl.registerLazySingleton(() => settingsRepository);
  }

  // blocs
}
