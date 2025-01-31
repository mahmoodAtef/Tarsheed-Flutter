import 'package:get_it/get_it.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    AuthRemoteServices authRemoteServices = AuthRemoteServices();
    sl.registerLazySingleton(() => authRemoteServices);
    AuthRepository authRepository = AuthRepository(authRemoteServices);
    sl.registerLazySingleton(() => authRemoteServices);
  }
}
