import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                      color: Color(0xFF727880),
                      offset: Offset(0, 4),
                      blurRadius: 4.r)
                ],
                color: Colors.grey[200],
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
                                color: Color(0xFF727880),
                                offset: Offset(0, 1),
                                blurRadius: 4.r)
                          ])),
                  SizedBox(height: 4.h),
                  Text(subtitle,
                      style: TextStyle(
                          color: Color(0xFF727880),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                                color: Color(0xFF727880),
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
