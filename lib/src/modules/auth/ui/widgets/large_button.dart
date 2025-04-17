import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/color_manager.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.title,
    this.icon,
    this.width,
    this.onPressed,
    this.isLoading = false,
  });

  final bool? isLoading;
  final String title;
  final Widget? icon;
  final double? width;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 55.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          disabledBackgroundColor: ColorManager.primary,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(
            ColorManager.primary.withOpacity(0.8),
          ),
        ),
        onPressed: isLoading == true ? null : onPressed,
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(color: ColorManager.white))
            : Row(
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
                    icon!,
                  ],
                ],
              ),
      ),
    );
  }
}
