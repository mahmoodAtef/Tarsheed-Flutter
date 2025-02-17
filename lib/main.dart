import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/home_page.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await LocalizationManager.init();
  runApp(BlocProvider(create: (context) => AuthBloc(), child: Tarsheed()));
}

class Tarsheed extends StatelessWidget {
  const Tarsheed({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
        colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.primary),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: Image.asset("assets/images/E-logo 1.png"),
        nextScreen: HomePage(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.white,
      ),
    );
  }
}
