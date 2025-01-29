import 'package:get_it/get_it.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    AuthRemoteServices placesRemoteDataSource = AuthRemoteServices();
    sl.registerLazySingleton(() => placesRemoteDataSource);
    AuthRepository authRepository = AuthRepository(placesRemoteDataSource);
    sl.registerLazySingleton(() => placesRemoteDataSource);
  }
}
