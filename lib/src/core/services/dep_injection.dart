import 'package:get_it/get_it.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_local_services.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    AuthRemoteServices authRemoteServices = AuthRemoteServices();
    AuthLocalServices authLocalServices = AuthLocalServices();
    sl.registerLazySingleton(() => authRemoteServices);
    AuthRepository authRepository =
        AuthRepository(authRemoteServices, authLocalServices);
    sl.registerLazySingleton(() => authRepository);
  }
}
