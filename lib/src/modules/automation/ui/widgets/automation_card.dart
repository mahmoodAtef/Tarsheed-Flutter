import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/modules/automation/data/models/action/action.dart';
import 'package:tarsheed/src/modules/automation/data/models/automation.dart';
import 'package:tarsheed/src/modules/automation/data/models/trigger/trigger.dart';

class AutomationCard extends StatelessWidget {
  final Automation automation;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final bool isEnabled;

  const AutomationCard({
    super.key,
    required this.automation,
    this.onTap,
    this.onToggle,
    this.onDelete,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: theme.cardTheme.elevation ?? 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isEnabled
              ? colorScheme.primary.withOpacity(0.2)
              : colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isEnabled
                ? colorScheme.surface
                : colorScheme.surface.withOpacity(0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              SizedBox(height: 12.h),
              _buildTriggerInfo(context),
              SizedBox(height: 8.h),
              _buildActionsInfo(context),
              SizedBox(height: 12.h),
              _buildStatusToggle(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            automation.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isEnabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.6),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'delete':
                onDelete?.call();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: colorScheme.error,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    S.of(context).delete,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
          child: Icon(
            Icons.more_vert,
            color: colorScheme.onSurface.withOpacity(0.6),
            size: 20.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildTriggerInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String triggerText = '';
    IconData triggerIcon = Icons.schedule;
    Color triggerColor = colorScheme.primary;

    if (automation.trigger is ScheduleTrigger) {
      final scheduleTrigger = automation.trigger as ScheduleTrigger;
      triggerText = '${S.of(context).schedule}: ${scheduleTrigger.time}';
      triggerIcon = Icons.schedule;
      triggerColor = colorScheme.primary;
    } else if (automation.trigger is SensorTrigger) {
      final sensorTrigger = automation.trigger as SensorTrigger;
      triggerText = '${S.of(context).sensor}: ${sensorTrigger.value}';
      triggerIcon = Icons.sensors;
      triggerColor = colorScheme.secondary;
    }

    final effectiveColor =
        isEnabled ? triggerColor : colorScheme.onSurface.withOpacity(0.6);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            triggerIcon,
            size: 16.sp,
            color: effectiveColor,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              triggerText,
              style: theme.textTheme.labelMedium?.copyWith(
                color: effectiveColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final deviceActions = automation.actions.whereType<DeviceAction>().length;
    final notificationActions =
        automation.actions.whereType<NotificationAction>().length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).actions,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isEnabled
                ? colorScheme.onSurface.withOpacity(0.6)
                : colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 4.h,
          children: [
            if (deviceActions > 0)
              _buildActionChip(
                context,
                Icons.devices,
                '$deviceActions ${S.of(context).devices}',
                colorScheme.secondary,
              ),
            if (notificationActions > 0)
              _buildActionChip(
                context,
                Icons.notifications,
                '$notificationActions ${S.of(context).notifications}',
                colorScheme.tertiary ?? colorScheme.secondary,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionChip(
      BuildContext context, IconData icon, String text, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveColor =
        isEnabled ? color : colorScheme.onSurface.withOpacity(0.6);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.sp,
            color: effectiveColor,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            isEnabled ? S.of(context).enabled : S.of(context).disabled,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isEnabled
                  ? colorScheme.secondary
                  : colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Switch(
          value: isEnabled,
          onChanged: (value) => onToggle?.call(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
