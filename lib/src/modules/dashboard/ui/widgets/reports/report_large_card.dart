import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildInfoCard extends StatelessWidget {
  final Widget? iconWidget;
  final IconData? icon;
  final String? title;
  final String? value;
  final String? percentage;
  final bool? isDecrease;
  final Color? color;
  final String? roomName;

  const BuildInfoCard({
    this.iconWidget,
    this.icon,
    required this.title,
    required this.value,
    this.percentage,
    this.isDecrease,
    this.color,
    this.roomName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surface,
      elevation: theme.cardTheme.elevation ?? 2,
      shape: theme.cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: color ?? colorScheme.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(8.w),
              child: iconWidget ??
                  Icon(
                    icon ?? Icons.info,
                    color: colorScheme.onPrimary,
                    size: 24.sp,
                  ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'No Title',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value ?? 'No Value',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            _buildTrailingWidget(context, theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingWidget(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    if (roomName != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          roomName!,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      final isDecreasing = isDecrease ?? true;
      final indicatorColor =
          isDecreasing ? (color ?? colorScheme.primary) : colorScheme.error;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDecreasing
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: indicatorColor,
              size: 20.sp,
            ),
            SizedBox(width: 2.w),
            Text(
              percentage ?? '0%',
              style: theme.textTheme.titleMedium?.copyWith(
                color: indicatorColor,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      );
    }
  }
}
