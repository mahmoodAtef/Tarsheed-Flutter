import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tarsheed/src/core/services/connectivity_services.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_local_services.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';
import 'package:tarsheed/src/modules/automation/cubit/automation_cubit.dart';
import 'package:tarsheed/src/modules/automation/data/repositories/repository.dart';
import 'package:tarsheed/src/modules/automation/data/services/automation_services.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/reports_cubit/reports_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/dashboard_repository.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/devices/devices_repository.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/report/report_repository.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_local_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_remote_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/devices/devices_remote_services.dart';
import 'package:tarsheed/src/modules/notifications/cubit/notifications_cubit.dart';
import 'package:tarsheed/src/modules/notifications/data/repositories/notifications_repository.dart';
import 'package:tarsheed/src/modules/notifications/data/services/base_notifications_services.dart';
import 'package:tarsheed/src/modules/notifications/data/services/notifications_services.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/data/services/settings_local_services.dart';
import 'package:tarsheed/src/modules/settings/data/services/settings_remote_services.dart';

import '../../modules/dashboard/data/services/report/report_remote_services.dart';
import '../../modules/settings/data/repositories/settings_repository.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    _initializeRemoteServices();
    _initializeLocalServices();
    _initializeRepositories();
    _initializeBlocs();
  }

  static void _initializeBlocs() {
    sl.registerSingleton<AuthBloc>(AuthBloc());
    sl.registerSingleton<SettingsCubit>(SettingsCubit());
    sl.registerLazySingleton<DashboardBloc>(() => DashboardBloc());
    // cubits
    sl.registerSingleton<DevicesCubit>(DevicesCubit());
    sl.registerLazySingleton(() => AutomationCubit());
    sl.registerLazySingleton(() => ReportsCubit(sl<ReportsRepository>()));
    sl.registerLazySingleton(
        () => NotificationsCubit(sl<NotificationsRepository>()));
  }

  static void _initializeRemoteServices() {
    sl.registerSingleton<BaseSettingsRemoteServices>(SettingsRemoteServices());
    sl.registerSingleton<BaseAuthRemoteServices>(
      AuthRemoteServices(),
    );
    sl.registerLazySingleton<DashboardRemoteServices>(
        () => DashboardRemoteServices());
    sl.registerLazySingleton<DevicesRemoteServices>(
        () => DevicesRemoteServices());

    sl.registerLazySingleton<BaseAutomationServices>(
        () => AutomationRemoteServices());
    sl.registerLazySingleton<BaseReportService>(() => ReportRemoteServices());
    // notifications
    sl.registerLazySingleton<BaseNotificationsService>(
        () => NotificationsRemoteService());
  }

  static void _initializeLocalServices() {
    sl.registerLazySingleton<LocalAuthentication>(
        () => LocalAuthentication()); // for local auth package
    sl.registerLazySingleton<BaseAuthLocalServices>(
        () => AuthLocalServices(auth: sl()));
    sl.registerLazySingleton<BaseSettingsLocalServices>(
        () => SettingsLocalServices());
    sl.registerLazySingleton<DashboardLocalServices>(
        () => DashboardLocalServices());
  }

  static void _initializeRepositories() {
    sl.registerLazySingleton(() => ConnectivityService()..initialize());
    sl.registerLazySingleton(() => AuthRepository(sl(), sl()));
    sl.registerLazySingleton(() => SettingsRepository(sl(), sl()));
    sl.registerLazySingleton(() => DashboardRepository(sl(), sl(), sl()));
    sl.registerLazySingleton(() => DevicesRepository(sl()));
    sl.registerLazySingleton(() => AutomationRepository(sl()));
    sl.registerLazySingleton(() => ReportsRepository(sl()));
    sl.registerLazySingleton(() => NotificationsRepository(sl()));
  }
}
