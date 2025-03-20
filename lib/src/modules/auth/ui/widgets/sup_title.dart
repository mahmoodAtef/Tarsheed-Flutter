import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class SupTitle extends StatelessWidget {
  const SupTitle({required this.text2, this.width, this.fontWeight, this.size});

  final String text2;
  final double? width;
  final FontWeight? fontWeight;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 60.h,
        width: width ?? 300.w,
        child: Text(
          text2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size ?? 14.sp,
            color: ColorManager.black,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
