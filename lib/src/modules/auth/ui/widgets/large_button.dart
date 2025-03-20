import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {super.key,
      required this.title,
      this.icon,
      this.width,
      this.onPressed,
      this.isLoading});

  final bool? isLoading;
  final String title;
  final IconData? icon;
  final double? width;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
            width: width ?? double.infinity,
            height: 55.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: ColorManager.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (icon != null) ...[
                    SizedBox(width: 10.w),
                    Icon(icon, size: 22.sp, color: ColorManager.white),
                  ],
                ],
              ),
            ),
          );
  }
}
