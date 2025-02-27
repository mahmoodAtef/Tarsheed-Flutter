import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_local_services.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';
import 'package:tarsheed/src/modules/settings/data/services/settings_local_services.dart';
import 'package:tarsheed/src/modules/settings/data/services/settings_remote_services.dart';

import '../../modules/settings/data/repositories/settings_repository.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    sl.registerSingleton<LocalAuthentication>(LocalAuthentication());
    AuthLocalServices authLocalServices = AuthLocalServices(auth: sl());
    sl.registerSingleton<AuthLocalServices>(authLocalServices);

    AuthRemoteServices authRemoteServices = AuthRemoteServices();
    sl.registerSingleton<AuthRemoteServices>(authRemoteServices);

    AuthRepository authRepository =
        AuthRepository(authRemoteServices, authLocalServices);
    sl.registerSingleton<AuthRepository>(authRepository);

    SettingsLocalServices settingsLocalServices = SettingsLocalServices();
    sl.registerSingleton<SettingsLocalServices>(settingsLocalServices);

    SettingsRemoteServices settingsRemoteServices = SettingsRemoteServices();
    sl.registerSingleton<SettingsRemoteServices>(settingsRemoteServices);

    SettingsRepository settingsRepository =
        SettingsRepository(settingsRemoteServices, settingsLocalServices);
    sl.registerSingleton<SettingsRepository>(settingsRepository);
  }

  // blocs
}
