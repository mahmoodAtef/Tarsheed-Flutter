import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/image_manager.dart';
import 'circle_background.dart';

class BackGroundRectangle extends StatelessWidget {
  const BackGroundRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0.h, // 2% من ارتفاع الشاشة
          child: Image.asset(AssetsManager.rectangle3),
        ),
        Positioned(
          bottom: 0.h, // نفس النسبة
          child: Image.asset(AssetsManager.rectangle4),
        ),
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          painter: BackgroundCircle(),
        ),
      ],
    );
  }
}
