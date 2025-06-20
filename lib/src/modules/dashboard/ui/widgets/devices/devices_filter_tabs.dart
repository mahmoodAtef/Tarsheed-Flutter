import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';

class FilterTabsRow extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabSelected;

  const FilterTabsRow({
    Key? key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          _buildTab(context, S.of(context).consumption, 0),
          _buildTab(context, S.of(context).rooms, 1),
          _buildTab(context, S.of(context).priority, 2),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final theme = Theme.of(context);
    final isSelected = selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
