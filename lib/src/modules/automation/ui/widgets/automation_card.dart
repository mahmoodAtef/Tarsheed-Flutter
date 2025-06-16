import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
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
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isEnabled
              ? ColorManager.primary.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
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
            color: isEnabled ? Colors.white : Colors.grey.shade50,
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
    return Row(
      children: [
        Expanded(
          child: Text(
            automation.name,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isEnabled ? Colors.black87 : Colors.grey.shade600,
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
                  const Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8.w),
                  Text(S.of(context).delete),
                ],
              ),
            ),
          ],
          child: Icon(
            Icons.more_vert,
            color: Colors.grey.shade600,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildTriggerInfo(BuildContext context) {
    String triggerText = '';
    IconData triggerIcon = Icons.schedule;
    Color triggerColor = ColorManager.primary;

    if (automation.trigger is ScheduleTrigger) {
      final scheduleTrigger = automation.trigger as ScheduleTrigger;
      triggerText = '${S.of(context).schedule}: ${scheduleTrigger.time}';
      triggerIcon = Icons.schedule;
      triggerColor = ColorManager.primary;
    } else if (automation.trigger is SensorTrigger) {
      final sensorTrigger = automation.trigger as SensorTrigger;
      triggerText = '${S.of(context).sensor}: ${sensorTrigger.value}';
      triggerIcon = Icons.sensors;
      triggerColor = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: (isEnabled ? triggerColor : Colors.grey).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            triggerIcon,
            size: 16,
            color: isEnabled ? triggerColor : Colors.grey.shade600,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              triggerText,
              style: TextStyle(
                fontSize: 12.sp,
                color: isEnabled ? triggerColor : Colors.grey.shade600,
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
    final deviceActions = automation.actions.whereType<DeviceAction>().length;
    final notificationActions =
        automation.actions.whereType<NotificationAction>().length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).actions,
          style: TextStyle(
            fontSize: 12.sp,
            color: isEnabled ? Colors.grey.shade600 : Colors.grey.shade500,
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
                Colors.green,
              ),
            if (notificationActions > 0)
              _buildActionChip(
                context,
                Icons.notifications,
                '$notificationActions ${S.of(context).notifications}',
                Colors.purple,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionChip(
      BuildContext context, IconData icon, String text, Color color) {
    final effectiveColor = isEnabled ? color : Colors.grey.shade600;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: effectiveColor),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              color: effectiveColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            isEnabled ? S.of(context).enabled : S.of(context).disabled,
            style: TextStyle(
              fontSize: 12.sp,
              color: isEnabled ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Switch(
          value: isEnabled,
          onChanged: (value) => onToggle?.call(),
          activeColor: ColorManager.activeBlue,
          inactiveThumbColor: Colors.grey.shade400,
          inactiveTrackColor: Colors.grey.shade300,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
