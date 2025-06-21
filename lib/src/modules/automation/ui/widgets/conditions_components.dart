// condition_components.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/modules/automation/ui/ui_models/ui_models.dart';
import 'package:tarsheed/src/modules/automation/ui/widgets/components.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';

class ConditionCard extends StatelessWidget {
  final ConditionData condition;
  final VoidCallback onDelete;
  final Function(String?) onIdChanged;
  final Function(int) onStateChanged;
  final Function(String) onOperatorChanged;

  const ConditionCard({
    super.key,
    required this.condition,
    required this.onDelete,
    required this.onIdChanged,
    required this.onStateChanged,
    required this.onOperatorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, dashboardState) {
        return BlocBuilder<DevicesCubit, DevicesState>(
          builder: (context, devicesState) {
            final sensors = context.read<DashboardBloc>().sensors;
            final devices = devicesState.devices ?? [];

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        condition.type == ConditionType.device
                            ? Icons.devices
                            : Icons.sensors,
                        color: theme.colorScheme.primary,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          condition.type == ConditionType.device
                              ? S.of(context).deviceCondition
                              : S.of(context).sensorCondition,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          Icons.delete,
                          color: theme.colorScheme.error,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: condition.id,
                          decoration: InputDecoration(
                            labelText: condition.type == ConditionType.device
                                ? S.of(context).selectDevice
                                : S.of(context).selectSensor,
                            fillColor:
                                theme.colorScheme.surface.withOpacity(0.5),
                          ),
                          items: condition.type == ConditionType.device
                              ? _buildDeviceItems(context, devices)
                              : _buildSensorItems(context, sensors),
                          onChanged: onIdChanged,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Add operator dropdown for sensor conditions
                      if (condition.type == ConditionType.sensor) ...[
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: condition.operator,
                            decoration: InputDecoration(
                              labelText: S.of(context).operator,
                              fillColor:
                                  theme.colorScheme.surface.withOpacity(0.5),
                            ),
                            items: _buildOperatorItems(context),
                            onChanged: (value) =>
                                onOperatorChanged(value ?? '='),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Expanded(
                        flex: condition.type == ConditionType.sensor ? 1 : 2,
                        child: condition.type == ConditionType.device
                            ? DropdownButtonFormField<int>(
                                value:
                                    condition.state == 0 || condition.state == 1
                                        ? condition.state
                                        : null,
                                decoration: InputDecoration(
                                  labelText: S.of(context).stateValue,
                                  fillColor: theme.colorScheme.surface
                                      .withOpacity(0.5),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text(S.of(context).turnOn),
                                  ),
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text(S.of(context).turnOff),
                                  ),
                                ],
                                onChanged: (value) =>
                                    onStateChanged(value ?? 0),
                              )
                            : TextFormField(
                                decoration: InputDecoration(
                                  labelText: S.of(context).value,
                                  fillColor: theme.colorScheme.surface
                                      .withOpacity(0.5),
                                ),
                                keyboardType: TextInputType.number,
                                initialValue: condition.state.toString(),
                                onChanged: (value) =>
                                    onStateChanged(int.tryParse(value) ?? 0),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _buildDeviceItems(
      BuildContext context, List<Device> devices) {
    if (devices.isEmpty) {
      return [
        DropdownMenuItem(
          value: null,
          child: Text(S.of(context).noDevicesAvailable),
        ),
      ];
    }
    return devices.map((device) {
      return DropdownMenuItem(
        value: device.id,
        child: Text(device.name),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildSensorItems(
      BuildContext context, List<Sensor> sensors) {
    if (sensors.isEmpty) {
      return [
        DropdownMenuItem(
          value: null,
          child: Text(S.of(context).noSensorsAvailable),
        ),
      ];
    }
    return sensors.map((sensor) {
      return DropdownMenuItem(
        value: sensor.id,
        child: Text(sensor.name),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildOperatorItems(BuildContext context) {
    return [
      const DropdownMenuItem(
        value: '=',
        child: Text('='),
      ),
      const DropdownMenuItem(
        value: '>',
        child: Text('>'),
      ),
      const DropdownMenuItem(
        value: '<',
        child: Text('<'),
      ),
      const DropdownMenuItem(
        value: '>=',
        child: Text('>='),
      ),
      const DropdownMenuItem(
        value: '<=',
        child: Text('<='),
      ),
    ];
  }
}

class AddConditionButtons extends StatelessWidget {
  final VoidCallback onAddDeviceCondition;
  final VoidCallback onAddSensorCondition;

  const AddConditionButtons({
    super.key,
    required this.onAddDeviceCondition,
    required this.onAddSensorCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AddButton(
            title: S.of(context).addDeviceCondition,
            icon: Icons.devices,
            onTap: onAddDeviceCondition,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AddButton(
            title: S.of(context).addSensorCondition,
            icon: Icons.sensors,
            onTap: onAddSensorCondition,
          ),
        ),
      ],
    );
  }
}

class ConditionsList extends StatelessWidget {
  final List<ConditionData> conditions;
  final Function(ConditionData) onDeleteCondition;
  final Function(ConditionData, String?) onConditionIdChanged;
  final Function(ConditionData, int) onConditionStateChanged;
  final Function(ConditionData, String) onConditionOperatorChanged;

  const ConditionsList({
    super.key,
    required this.conditions,
    required this.onDeleteCondition,
    required this.onConditionIdChanged,
    required this.onConditionStateChanged,
    required this.onConditionOperatorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (conditions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 48.w,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            SizedBox(height: 12.h),
            Text(
              S.of(context).noConditionsAdded,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            S.of(context).conditions,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...conditions.asMap().entries.map((entry) {
          final index = entry.key;
          final condition = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 12.h,
            ),
            child: ConditionCard(
              condition: condition,
              onDelete: () => onDeleteCondition(condition),
              onIdChanged: (value) => onConditionIdChanged(condition, value),
              onStateChanged: (value) =>
                  onConditionStateChanged(condition, value),
              onOperatorChanged: (value) =>
                  onConditionOperatorChanged(condition, value),
            ),
          );
        }).toList(),
      ],
    );
  }
}
