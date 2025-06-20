import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextWidget extends StatelessWidget {
  final String label;
  final double size;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  final bool enableShadow;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomTextWidget({
    Key? key,
    required this.label,
    required this.size,
    this.textAlign = TextAlign.center,
    this.fontWeight,
    this.color,
    this.enableShadow = true,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  TextStyle _getTextStyle(BuildContext context, {double? fontSize}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextStyle(
      fontSize: fontSize?.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? colorScheme.onSurface,
      fontFamily: theme.textTheme.bodyLarge?.fontFamily,
      shadows: enableShadow
          ? [
              Shadow(
                color: colorScheme.shadow.withOpacity(0.3),
                offset: Offset(0, 1.h),
                blurRadius: 2.r,
              ),
            ]
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: _getTextStyle(context, fontSize: size),
    );
  }
}
