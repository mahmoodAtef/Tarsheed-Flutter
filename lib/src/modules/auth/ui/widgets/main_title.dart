import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({required this.mainText});

  final String mainText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        mainText,
        style: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.w700,
          color: ColorManager.primary,
        ),
      ),
    );
  }
}
