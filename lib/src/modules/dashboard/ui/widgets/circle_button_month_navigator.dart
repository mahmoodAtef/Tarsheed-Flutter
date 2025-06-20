import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 28.sp,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
