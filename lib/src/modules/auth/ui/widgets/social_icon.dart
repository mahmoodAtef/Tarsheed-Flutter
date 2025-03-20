import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class SocialIcon extends StatelessWidget {
  const SocialIcon({this.scale, required this.image, this.onPressed});

  final double? scale;
  final String image;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: 60.w,
      decoration: BoxDecoration(
          color: ColorManager.grey300,
          borderRadius: BorderRadius.circular(10.r)),
      child: IconButton(
          onPressed: onPressed,
          icon: Image.asset(
            image,
            scale: scale,
            fit: BoxFit.fill,
          )),
    );
  }
}
