import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class BuildItem extends StatelessWidget {
  const BuildItem(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            Container(
              height: 60.h,
              width: 40.w,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: ColorManager.steelGrey,
                      offset: Offset(0, 4),
                      blurRadius: 4.r)
                ],
                color: ColorManager.grey300,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Center(child: Icon(icon)),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          shadows: [
                            Shadow(
                                color: ColorManager.steelGrey,
                                offset: Offset(0, 1),
                                blurRadius: 4.r)
                          ])),
                  SizedBox(height: 4.h),
                  Text(subtitle,
                      style: TextStyle(
                          color: ColorManager.steelGrey,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                                color: ColorManager.steelGrey,
                                offset: Offset(0, 1),
                                blurRadius: 4.r)
                          ])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
