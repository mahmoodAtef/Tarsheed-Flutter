import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultButton extends StatelessWidget {
  final bool isLoading;
  final String title;
  final Widget? icon;
  final double? width;
  final VoidCallback? onPressed;

  const DefaultButton({
    super.key,
    required this.title,
    this.icon,
    this.width,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: 55.h,
      child: ElevatedButton(
        style: theme.elevatedButtonTheme.style?.copyWith(
          elevation: MaterialStateProperty.all(10),
          overlayColor: MaterialStateProperty.all(
            theme.colorScheme.primary.withOpacity(0.8),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.onPrimary,
                  strokeWidth: 2.w,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.elevatedButtonTheme.style?.textStyle
                            ?.resolve({MaterialState.pressed})?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ) ??
                        theme.textTheme.labelLarge?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
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
