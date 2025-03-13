import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tarsheed/src/core/services/connectivity_services.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_local_services.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/dashboard_repository.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_local_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_remote_services.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/data/services/settings_local_services.dart';
import 'package:tarsheed/src/modules/settings/data/services/settings_remote_services.dart';

import '../../modules/settings/data/repositories/settings_repository.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    _initializeLocalServices();
    _initializeRemoteServices();
    _initializeRepositories();
    _initializeBlocs();
  }

  static void _initializeBlocs() {
    sl.registerSingleton<AuthBloc>(AuthBloc());
    sl.registerSingleton<SettingsCubit>(SettingsCubit());
    sl.registerLazySingleton<DashboardBloc>(() => DashboardBloc());
  }

  static void _initializeRemoteServices() {
    sl.registerSingleton<SettingsRemoteServices>(SettingsRemoteServices());
    sl.registerSingleton<AuthRemoteServices>(AuthRemoteServices());
    sl.registerLazySingleton<DashboardRemoteServices>(
        () => DashboardRemoteServices());
  }

  static void _initializeLocalServices() {
    sl.registerSingleton<LocalAuthentication>(LocalAuthentication());
    sl.registerLazySingleton<AuthLocalServices>(
        () => AuthLocalServices(auth: sl()));
    sl.registerSingleton<SettingsLocalServices>(SettingsLocalServices());
    sl.registerLazySingleton<DashboardLocalServices>(
        () => DashboardLocalServices());
  }

  static void _initializeRepositories() {
    sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
    sl.registerSingleton<AuthRepository>(AuthRepository(sl(), sl()));
    sl.registerSingleton<SettingsRepository>(SettingsRepository(sl(), sl()));
    sl.registerSingleton<DashboardRepository>(
        DashboardRepository(sl(), sl(), sl()));
  }
}
