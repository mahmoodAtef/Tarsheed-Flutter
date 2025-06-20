import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/clock_widget.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/connected_devices_indicator.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/profile_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.r),
          bottom: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClockWidget(),
                SizedBox(height: 8.h),
                Text(
                  S.of(context).home,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                ConnectedDevicesIndicator(),
              ],
            ),
          ),
          const ProfileAvatar(),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => context.push(ProfilePage()),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 2.w,
              ),
            ),
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: colorScheme.surface,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/avatar.png",
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 30.sp,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 2.w,
            top: 2.h,
            child: Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surface,
                  width: 2.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
