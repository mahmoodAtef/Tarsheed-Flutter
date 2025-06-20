import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({
    super.key,
    required this.mainText,
  });

  final String mainText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        mainText,
        style: theme.textTheme.displayMedium?.copyWith(
          fontSize: 30.sp,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
