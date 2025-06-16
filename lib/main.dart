import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/services/app_initializer.dart';
import 'package:tarsheed/src/core/services/bloc_observer.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/core/utils/theme_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  AppInitializer.initializeServiceLocator();

  Bloc.observer = TarsheedBlocObserver();

  runApp(
    Tarsheed(),
  );
}

class Tarsheed extends StatelessWidget {
  const Tarsheed({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleText: () => true,
      builder: (BuildContext context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: true,
              create: (context) => SettingsCubit.get(),
            ),
            BlocProvider(
              create: (context) => AuthBloc.instance,
            ),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                current is ChangeLanguageSuccessState ||
                current is SettingsInitial,
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: LocalizationManager.getAppTitle(),
                locale: LocalizationManager.getCurrentLocale(),
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                theme: ThemeManager.lightTheme,
                home: SplashScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
/*

  */
