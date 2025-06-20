import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupTitle extends StatelessWidget {
  const SupTitle({
    super.key,
    required this.text2,
    this.width,
    this.fontWeight,
    this.size,
  });

  final String text2;
  final double? width;
  final FontWeight? fontWeight;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 60.h,
        width: width ?? 300.w,
        child: Text(
          text2,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: size ?? 14.sp,
            color: theme.colorScheme.onBackground,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
