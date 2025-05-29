import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/delete_confirmation_dialog.dart'
    show DeleteDeviceDialog;
import 'package:tarsheed/src/modules/dashboard/ui/widgets/edit_device_dialog.dart';

import '../../data/models/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final bool editable;
  final bool deletable;
  final bool toggleable;

  const DeviceCard(
      {super.key,
      required this.device,
      this.deletable = true,
      this.editable = true,
      this.toggleable = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesCubit, DevicesState>(
      buildWhen: (current, previous) =>
          ((current is ToggleDeviceStatusSuccess &&
                  current.deviceId == device.id) ||
              (current is ToggleDeviceStatusLoading &&
                  current.deviceId == device.id) ||
              (current is ToggleDeviceStatusError &&
                  current.deviceId == device.id)),
      builder: (context, state) {
        bool isActive =
            (state is ToggleDeviceStatusLoading && state.deviceId == device.id)
                ? !device.state
                : device.state;
        final textColor = isActive ? ColorManager.white : ColorManager.black;

        return SizedBox(
          height: 160.h,
          width: 180.w,
          child: GestureDetector(
            onLongPress: deletable ? () => _deleteDevice(context) : null,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive ? ColorManager.primary : ColorManager.grey200,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildCategoryIcon(textColor),
                          const Spacer(),
                          Switch(
                            value: isActive,
                            onChanged: toggleable
                                ? (s) => _toggleStatus(s, context)
                                : null,
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.grey.shade400,
                          ),
                        ],
                      ),
                      Text(
                        device.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device.description,
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.bolt,
                            size: 16,
                            color: textColor.withOpacity(0.9),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${device.consumption.toStringAsFixed(1)} kW/h',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.priority_high,
                            size: 16,
                            color: textColor.withOpacity(0.9),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getPriorityText(device.priority, context),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: editable ? () => _editDevice(context) : null,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: device.state
                              ? Colors.white24
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcon(Color color) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (current, previous) => current is DeviceCategoryState,
      builder: (context, state) {
        DeviceCategory category = context
            .read<DashboardBloc>()
            .categories
            .firstWhere((category) => category.id == device.categoryId,
                orElse: () => DeviceCategory.empty);
        return state is GetDeviceCategoriesLoading
            ? SizedBox()
            : Image.network(
                category.iconUrl,
                height: 40,
                width: 40,
                color: color,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.devices,
                    size: 40,
                    color: color,
                  );
                },
              );
      },
    );
  }

  String _getPriorityText(int priority, BuildContext context) {
    if (priority == 1) {
      return S.of(context).veryHigh;
    } else if (priority == 2) {
      return S.of(context).high;
    } else if (priority == 3) {
      return S.of(context).medium;
    }

    return S.of(context).low;
  }

  void _deleteDevice(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteDeviceDialog(deviceId: device.id),
    );
  }

  void _editDevice(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditDeviceDialog(device: device),
    );
  }

  void _toggleStatus(bool status, BuildContext context) {
    final DevicesCubit devicesCubit = context.read<DevicesCubit>();
    devicesCubit.toggleDeviceStatus(device.id);
  }
}
