import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';
import 'package:tarsheed/src/core/routing/app_router.dart';
import 'package:tarsheed/src/core/routing/routes.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await LocalizationManager.init();
  runApp(
      BlocProvider(create: (context) => AuthBloc.instance, child: Tarsheed()));
}

class Tarsheed extends StatelessWidget {
  const Tarsheed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (context) => SettingsCubit.getInstance,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => current is ChangeLanguageSuccessState,
        bloc: SettingsCubit.getInstance,
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
              theme: ThemeData(
                scaffoldBackgroundColor: ColorManager.white,
                colorScheme:
                    ColorScheme.fromSeed(seedColor: ColorManager.primary),
                useMaterial3: true,
              ),
              initialRoute: Routes.initialRoute,

              /// put your screens route here
              onGenerateRoute: AppRouter.onGenerateRoute,
              home: SplashScreen());
        },
      ),
    );
  }
}
