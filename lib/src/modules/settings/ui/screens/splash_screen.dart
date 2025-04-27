import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tarsheed/src/core/services/app_initializer.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      screenFunction: () async {
        return AppInitializer.init();
      },
      duration: 3000,
      splashIconSize: MediaQuery.of(context).size.shortestSide * 0.6,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      curve: Curves.bounceIn,
      splash: Image.asset(
        "assets/images/E-logo 1.png",
        fit: BoxFit.fill,
      ),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: ColorManager.white,
    );
  }
}
