import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialIcon extends StatelessWidget {
  const SocialIcon({
    super.key,
    this.scale,
    required this.image,
    this.onPressed,
  });

  final double? scale;
  final String image;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 44.h,
      width: 60.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Image.asset(
          image,
          scale: scale,
          color: theme.colorScheme.inverseSurface,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
