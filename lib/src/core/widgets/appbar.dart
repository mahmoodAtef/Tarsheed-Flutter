import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool withBackButton;
  final String text;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    required this.text,
    super.key,
    this.withBackButton = true,
    this.actions,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation,
      centerTitle: theme.appBarTheme.centerTitle,
      surfaceTintColor: theme.appBarTheme.surfaceTintColor,
      leading: leading ??
          (withBackButton == true
              ? IconButton(
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: theme.appBarTheme.foregroundColor,
                    size: 28.sp,
                  ),
                  onPressed: () => context.pop(),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                )
              : null),
      title: Text(
        text,
        style: theme.appBarTheme.titleTextStyle?.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      iconTheme: theme.appBarTheme.iconTheme?.copyWith(
        size: 24.sp,
      ),
    );
  }
}
