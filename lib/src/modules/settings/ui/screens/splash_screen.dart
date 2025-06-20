import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tarsheed/src/core/services/app_initializer.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSplashScreen.withScreenFunction(
      screenFunction: () async {
        return AppInitializer.init();
      },
      duration: 300,
      splashIconSize: _calculateSplashIconSize(context),
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      curve: Curves.bounceIn,
      splash: _buildSplashLogo(context, colorScheme),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: colorScheme.background,
    );
  }

  double _calculateSplashIconSize(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final shortestSide = screenSize.shortestSide;

    double iconSize = shortestSide * 0.6;

    iconSize = iconSize.clamp(200.w, 300.w);

    return iconSize;
  }

  Widget _buildSplashLogo(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2),
            blurRadius: 20.r,
            spreadRadius: 5.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Image.asset(
          AssetsManager.logo,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
