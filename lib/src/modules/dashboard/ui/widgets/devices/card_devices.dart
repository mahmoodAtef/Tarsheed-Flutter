import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/devices/delete_confirmation_dialog.dart'
    show DeleteDeviceDialog;
import 'package:tarsheed/src/modules/dashboard/ui/widgets/devices/edit_device_dialog.dart';

import '../../../data/models/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final bool editable;
  final bool deletable;
  final bool toggleable;

  const DeviceCard({
    super.key,
    required this.device,
    this.deletable = true,
    this.editable = true,
    this.toggleable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: DevicesCubit.get(),
        ),
        BlocProvider.value(
          value: DashboardBloc.get(),
        ),
      ],
      child: BlocBuilder<DevicesCubit, DevicesState>(
        buildWhen: (previous, current) {
          return current is ToggleDeviceStatusLoading ||
              current is ToggleDeviceStatusSuccess ||
              current is ToggleDeviceStatusError ||
              current is GetDevicesSuccess ||
              previous.devices != current.devices;
        },
        builder: (context, state) {
          final currentDevice = _getCurrentDevice(state);
          final isActive = currentDevice?.state ?? device.state;

          bool isToggling = false;
          if (state is ToggleDeviceStatusLoading &&
              state.deviceId == device.id) {
            isToggling = true;
          }

          return SizedBox(
            height: 160.h,
            width: 180.w,
            child: GestureDetector(
              onLongPress: deletable ? () => _deleteDevice(context) : null,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isActive
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 6.r,
                      offset: Offset(0, 3.h),
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
                            FittedBox(
                                child: _buildCategoryIcon(context, isActive)),
                            const Spacer(),
                            if (toggleable)
                              _buildToggleSwitch(context, isActive, isToggling),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        FittedBox(
                            fit: BoxFit.fill,
                            child: _buildDeviceName(
                                context, currentDevice, isActive)),
                        SizedBox(height: 4.h),
                        FittedBox(
                          child: _buildDeviceDescription(
                              context, currentDevice, isActive),
                        ),
                        SizedBox(height: 8.h),
                        FittedBox(
                            child: _buildConsumptionInfo(
                                context, currentDevice, isActive)),
                        SizedBox(height: 6.h),
                        Expanded(
                            child: _buildPriorityInfo(
                                context, currentDevice, isActive)),
                      ],
                    ),
                    if (editable) _buildEditButton(context, isActive),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToggleSwitch(
      BuildContext context, bool isActive, bool isToggling) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Switch(
          value: isActive,
          onChanged: toggleable && !isToggling
              ? (status) => _toggleStatus(status, context)
              : null,
        ),
        if (isToggling)
          SizedBox(
            width: 16.w,
            height: 16.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildDeviceName(
      BuildContext context, Device? currentDevice, bool isActive) {
    final theme = Theme.of(context);

    return Text(
      currentDevice?.name ?? device.name,
      style: theme.textTheme.titleLarge?.copyWith(
        color: isActive
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDeviceDescription(
      BuildContext context, Device? currentDevice, bool isActive) {
    final theme = Theme.of(context);

    return Text(
      currentDevice?.description ?? device.description,
      style: theme.textTheme.bodySmall?.copyWith(
        color: isActive
            ? theme.colorScheme.onPrimary.withOpacity(0.8)
            : theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildConsumptionInfo(
      BuildContext context, Device? currentDevice, bool isActive) {
    final theme = Theme.of(context);
    final textColor = isActive
        ? theme.colorScheme.onPrimary.withOpacity(0.9)
        : theme.colorScheme.onSurface.withOpacity(0.8);

    return Row(
      children: [
        Icon(
          Icons.bolt,
          size: 16.sp,
          color: textColor,
        ),
        SizedBox(width: 4.w),
        Text(
          '${(currentDevice?.consumption ?? device.consumption).toStringAsFixed(1)} kwh',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityInfo(
      BuildContext context, Device? currentDevice, bool isActive) {
    final theme = Theme.of(context);
    final textColor = isActive
        ? theme.colorScheme.onPrimary.withOpacity(0.9)
        : theme.colorScheme.onSurface.withOpacity(0.8);

    return Row(
      children: [
        Icon(
          Icons.priority_high,
          size: 16.sp,
          color: textColor,
        ),
        SizedBox(width: 4.w),
        Text(
          _getPriorityText(
            currentDevice?.priority ?? device.priority,
            context,
          ),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, bool isActive) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 4.h,
      right: 4.w,
      child: GestureDetector(
        onTap: editable ? () => _editDevice(context) : null,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.onPrimary.withOpacity(0.2)
                : theme.colorScheme.onSurface.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.edit,
            size: 16.sp,
            color: isActive
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Device? _getCurrentDevice(DevicesState state) {
    final devices = state.devices;
    if (devices == null) return null;

    try {
      return devices.firstWhere((d) => d.id == device.id);
    } catch (e) {
      return null;
    }
  }

  Widget _buildCategoryIcon(BuildContext context, bool isActive) {
    final theme = Theme.of(context);
    final iconColor =
        isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    List<DeviceCategory> categories = [];

    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is GetDeviceCategoriesError) {
          ExceptionManager.showMessage(state.exception);
        } else if (state is GetDeviceCategoriesSuccess) {
          categories = state.deviceCategories;
        }
      },
      buildWhen: (current, previous) => current is DeviceCategoryState,
      builder: (context, state) {
        if (state is GetDeviceCategoriesLoading) {
          return SizedBox(
            width: 40.w,
            height: 40.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: iconColor,
            ),
          );
        }

        final category = categories.firstWhere(
          (category) => category.id == device.categoryId,
          orElse: () => DeviceCategory.empty,
        );

        return SizedBox(
          width: 40.w,
          height: 40.h,
          child: Image.network(
            category.iconUrl,
            color: iconColor,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.devices,
                size: 40.sp,
                color: iconColor,
              );
            },
          ),
        );
      },
    );
  }

  String _getPriorityText(int priority, BuildContext context) {
    switch (priority) {
      case 1:
        return S.of(context).veryHigh;
      case 2:
        return S.of(context).high;
      case 3:
        return S.of(context).medium;
      default:
        return S.of(context).low;
    }
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
    final devicesCubit = DevicesCubit.get();
    devicesCubit.toggleDeviceStatus(device.id);
  }
}
