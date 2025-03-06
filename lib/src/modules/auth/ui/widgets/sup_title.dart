import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupTitle extends StatelessWidget {
  const SupTitle({required this.text2, this.width, this.fontweight, this.size});

  final String text2;
  final double? width;
  final FontWeight? fontweight;
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
            color: Colors.black,
            fontWeight: fontweight ?? FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
