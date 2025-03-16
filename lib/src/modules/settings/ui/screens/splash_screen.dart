import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import "package:page_transition/page_transition.dart";
import 'package:tarsheed/src/core/services/app_initializer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      screenFunction: () => AppInitializer.init(),
      duration: 3000,
      splashIconSize: MediaQuery.of(context).size.shortestSide * 0.6,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      curve: Curves.bounceIn,
      splash: Image.asset(
        fit: BoxFit.fill,
        "assets/images/E-logo 1.png",
      ),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}
