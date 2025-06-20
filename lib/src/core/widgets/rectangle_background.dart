import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/image_manager.dart';
import 'circle_background.dart';

class BackGroundRectangle extends StatelessWidget {
  const BackGroundRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned(
          bottom: 0.h,
          child: Image.asset(
            AssetsManager.rectangle3,
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
        ),
        Positioned(
          bottom: 0.h,
          child: Image.asset(
            AssetsManager.rectangle4,
            color: theme.colorScheme.primary.withOpacity(0.15),
          ),
        ),
        CustomPaint(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
          painter: BackgroundCircle(colorScheme: theme.colorScheme),
        ),
      ],
    );
  }
}
