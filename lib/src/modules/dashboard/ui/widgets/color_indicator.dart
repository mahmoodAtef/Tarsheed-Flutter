import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorIndicator extends StatelessWidget {
  final Color color;
  final String label;

  const ColorIndicator({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
