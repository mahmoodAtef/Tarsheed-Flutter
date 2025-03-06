import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialIcon extends StatelessWidget {
  const SocialIcon({this.scale, required this.image});

  final double? scale;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: 60.w,
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r)),
      child: IconButton(
          onPressed: () {},
          icon: Image.asset(
            image,
            scale: scale,
            fit: BoxFit.fill,
          )),
    );
  }
}
