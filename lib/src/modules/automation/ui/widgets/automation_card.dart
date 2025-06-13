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
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.w,
      height: 200.h,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isEnabled
                  ? ColorManager.primary.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 12.h),
                _buildTriggerInfo(context),
                SizedBox(height: 8.h),
                _buildActionsInfo(context),
                const Spacer(),
                _buildStatusToggle(context),
              ],
            ),
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
              color: Colors.black87,
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
        color: triggerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            triggerIcon,
            size: 16,
            color: triggerColor,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              triggerText,
              style: TextStyle(
                fontSize: 12.sp,
                color: triggerColor,
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
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            if (deviceActions > 0) ...[
              _buildActionChip(
                context,
                Icons.devices,
                '$deviceActions ${S.of(context).devices}',
                Colors.green,
              ),
              SizedBox(width: 8.w),
            ],
            if (notificationActions > 0) ...[
              _buildActionChip(
                context,
                Icons.notifications,
                '$notificationActions ${S.of(context).notifications}',
                Colors.purple,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionChip(
      BuildContext context, IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: isEnabled,
          onChanged: (value) => onToggle?.call(),
          activeColor: ColorManager.activeBlue,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
