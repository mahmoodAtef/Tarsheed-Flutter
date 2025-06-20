// automation_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';

// Helper enums and classes
enum TriggerType { schedule, sensor }

enum ConditionType { device, sensor }

enum ActionType { device, notification }

class ConditionData {
  final ConditionType type;
  String? id;
  int state = 0;
  String operator = '='; // Default operator for sensor conditions

  ConditionData({required this.type});
}

class ActionData {
  final ActionType type;
  String? deviceId;
  String? state;
  String? title;
  String? message;

  ActionData({required this.type});
}

class AutomationSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const AutomationSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 20.sp,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 4.h),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
        SizedBox(height: 16.h),
        child,
      ],
    );
  }
}

// 2. Selectable Card Widget
class SelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Add Button Widget
class AddButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AddButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. Trigger Type Selector Widget
class TriggerTypeSelector extends StatelessWidget {
  final TriggerType selectedTriggerType;
  final Function(TriggerType) onTriggerTypeChanged;

  const TriggerTypeSelector({
    super.key,
    required this.selectedTriggerType,
    required this.onTriggerTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectableCard(
            title: S.of(context).schedule,
            subtitle: S.of(context).runAtSpecificTime,
            icon: Icons.schedule,
            isSelected: selectedTriggerType == TriggerType.schedule,
            onTap: () => onTriggerTypeChanged(TriggerType.schedule),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SelectableCard(
            title: S.of(context).sensor,
            subtitle: S.of(context).runWhenSensorValueChanges,
            icon: Icons.sensors,
            isSelected: selectedTriggerType == TriggerType.sensor,
            onTap: () => onTriggerTypeChanged(TriggerType.sensor),
          ),
        ),
      ],
    );
  }
}

// 6. Time Selector Widget
class TimeSelector extends StatelessWidget {
  final String? selectedTime;
  final Function(String?) onTimeSelected;

  const TimeSelector({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          final timeString =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          onTimeSelected(timeString);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: theme.colorScheme.primary,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              selectedTime ?? S.of(context).selectTime,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16.sp,
                fontWeight:
                    selectedTime != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: theme.iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}

// 7. Sensor Trigger Selector Widget
class SensorTriggerSelector extends StatelessWidget {
  final String? selectedSensorId;
  final int? triggerValue;
  final String? selectedOperator;
  final Function(String?) onSensorSelected;
  final Function(int?) onTriggerValueChanged;
  final Function(String?) onOperatorChanged;

  const SensorTriggerSelector({
    super.key,
    required this.selectedSensorId,
    required this.triggerValue,
    required this.selectedOperator,
    required this.onSensorSelected,
    required this.onTriggerValueChanged,
    required this.onOperatorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          current is GetSensorsSuccessState ||
          current is GetSensorsLoadingState ||
          current is GetSensorsErrorState,
      builder: (context, state) {
        if (state is GetSensorsLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        final sensors = context.read<DashboardBloc>().sensors;
        final sensorItems = _buildSensorItems(context, sensors);

        return Column(
          children: [
            // Sensor Selection
            DropdownButtonFormField<String>(
              value: selectedSensorId,
              decoration: InputDecoration(
                labelText: S.of(context).selectSensor,
                prefixIcon: Icon(
                  Icons.sensors,
                  color: theme.colorScheme.primary,
                ),
              ),
              items: sensorItems,
              onChanged: onSensorSelected,
            ),
            SizedBox(height: 12.h),

            // Operator Selection
            DropdownButtonFormField<String>(
              value: selectedOperator,
              decoration: InputDecoration(
                labelText: S.of(context).operator,
                prefixIcon: Icon(
                  Icons.compare_arrows,
                  color: theme.colorScheme.primary,
                ),
              ),
              items: _buildOperatorItems(context),
              onChanged: onOperatorChanged,
            ),
            SizedBox(height: 12.h),

            // Trigger Value
            TextFormField(
              decoration: InputDecoration(
                labelText: S.of(context).triggerValue,
                prefixIcon: Icon(
                  Icons.numbers,
                  color: theme.colorScheme.primary,
                ),
              ),
              keyboardType: TextInputType.number,
              initialValue: triggerValue?.toString(),
              onChanged: (value) => onTriggerValueChanged(int.tryParse(value)),
            ),
          ],
        );
      },
    );
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
      DropdownMenuItem(
        value: '==',
        child: Row(
          children: [
            SizedBox(width: 8.w),
            const Text('=='),
          ],
        ),
      ),
      DropdownMenuItem(
        value: '>',
        child: Row(
          children: [
            SizedBox(width: 8.w),
            const Text('>'),
          ],
        ),
      ),
      DropdownMenuItem(
        value: '<',
        child: Row(
          children: [
            SizedBox(width: 8.w),
            const Text('<'),
          ],
        ),
      ),
      DropdownMenuItem(
        value: '>=',
        child: Row(
          children: [
            SizedBox(width: 8.w),
            const Text('>='),
          ],
        ),
      ),
      DropdownMenuItem(
        value: '<=',
        child: Row(
          children: [
            SizedBox(width: 8.w),
            const Text('<='),
          ],
        ),
      ),
    ];
  }
}

// 8. Condition Card Widget
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

// 9. Action Card Widget
class ActionCard extends StatelessWidget {
  final ActionData action;
  final VoidCallback onDelete;
  final Function(String) onDeviceIdChanged;
  final Function(String) onStateChanged;
  final Function(String) onTitleChanged;
  final Function(String) onMessageChanged;

  const ActionCard({
    super.key,
    required this.action,
    required this.onDelete,
    required this.onDeviceIdChanged,
    required this.onStateChanged,
    required this.onTitleChanged,
    required this.onMessageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: theme.cardTheme.elevation,
      color: theme.cardTheme.color,
      shape: theme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  action.type == ActionType.device
                      ? Icons.power_settings_new
                      : Icons.notifications,
                  color: theme.colorScheme.primary,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  action.type == ActionType.device
                      ? S.of(context).deviceAction
                      : S.of(context).notificationAction,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (action.type == ActionType.device) ...[
              _buildDeviceActionFields(context),
            ] else ...[
              _buildNotificationActionFields(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceActionFields(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Device Selector
        BlocBuilder<DevicesCubit, DevicesState>(
          builder: (context, state) {
            if (state is GetDevicesSuccess) {
              final devices = state.devices;
              final deviceItems = devices?.map((device) {
                return DropdownMenuItem<String>(
                  value: device.id,
                  child: Text(device.name),
                );
              }).toList();

              String? validSelectedValue = action.deviceId;
              if (validSelectedValue != null &&
                  !devices!.any((device) => device.id == validSelectedValue)) {
                validSelectedValue = null;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onDeviceIdChanged('');
                });
              }

              return DropdownButtonFormField<String>(
                key: ValueKey('device_${action.hashCode}'),
                value: validSelectedValue,
                decoration: InputDecoration(
                  labelText: S.of(context).selectDevice,
                ),
                items: deviceItems,
                onChanged: (value) {
                  if (value != null) {
                    onDeviceIdChanged(value);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).pleaseSelectDevice;
                  }
                  return null;
                },
              );
            }
            return CircularProgressIndicator(
              color: theme.colorScheme.primary,
            );
          },
        ),
        SizedBox(height: 16.h),

        // State Selector
        DropdownButtonFormField<String>(
          key: ValueKey('state_${action.hashCode}'),
          value: _getValidStateValue(),
          decoration: InputDecoration(
            labelText: S.of(context).deviceState,
          ),
          items: _getStateDropdownItems(context),
          onChanged: (value) {
            if (value != null) {
              onStateChanged(value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).pleaseSelectState;
            }
            return null;
          },
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getStateDropdownItems(BuildContext context) {
    return [
      DropdownMenuItem<String>(
        value: 'turned_on',
        child: Text(S.of(context).turnOn),
      ),
      DropdownMenuItem<String>(
        value: 'turned_off',
        child: Text(S.of(context).turnOff),
      ),
    ];
  }

  String? _getValidStateValue() {
    const validStates = ['turned_on', 'turned_off'];
    if (action.state != null && validStates.contains(action.state)) {
      return action.state;
    }
    return null;
  }

  Widget _buildNotificationActionFields(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TextFormField(
          key: ValueKey('title_${action.hashCode}'),
          initialValue: action.title,
          decoration: InputDecoration(
            labelText: S.of(context).notificationTitle,
            prefixIcon: Icon(
              Icons.title,
              color: theme.colorScheme.primary,
            ),
          ),
          onChanged: onTitleChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).pleaseEnterTitle;
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          key: ValueKey('message_${action.hashCode}'),
          initialValue: action.message,
          decoration: InputDecoration(
            labelText: S.of(context).notificationMessage,
            prefixIcon: Icon(
              Icons.message,
              color: theme.colorScheme.primary,
            ),
          ),
          maxLines: 3,
          onChanged: onMessageChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).pleaseEnterMessage;
            }
            return null;
          },
        ),
      ],
    );
  }
}

// 10. Add Condition Buttons Widget
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

// 11. Add Action Buttons Widget
class AddActionButtons extends StatelessWidget {
  final VoidCallback onAddDeviceAction;
  final VoidCallback onAddNotificationAction;

  const AddActionButtons({
    super.key,
    required this.onAddDeviceAction,
    required this.onAddNotificationAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AddButton(
            title: S.of(context).addDeviceAction,
            icon: Icons.devices,
            onTap: onAddDeviceAction,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AddButton(
            title: S.of(context).addNotification,
            icon: Icons.notifications,
            onTap: onAddNotificationAction,
          ),
        ),
      ],
    );
  }
}

// 12. Save Button Widget
class AutomationSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String buttonText;

  const AutomationSaveButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: theme.elevatedButtonTheme.style,
        child: isLoading
            ? CircularProgressIndicator(
                color: theme.colorScheme.onPrimary,
              )
            : Text(
                buttonText,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 16.sp,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }
}

// 13. Trigger Details Widget (combines time and sensor selectors)
// Trigger Details Widget
class TriggerDetails extends StatelessWidget {
  final TriggerType triggerType;
  final String? selectedTime;
  final String? selectedSensorId;
  final int? triggerValue;
  final String? selectedOperator;
  final Function(String?) onTimeSelected;
  final Function(String?) onSensorSelected;
  final Function(int?) onTriggerValueChanged;
  final Function(String?) onOperatorChanged;

  const TriggerDetails({
    super.key,
    required this.triggerType,
    required this.selectedTime,
    required this.selectedSensorId,
    required this.triggerValue,
    required this.selectedOperator,
    required this.onTimeSelected,
    required this.onSensorSelected,
    required this.onTriggerValueChanged,
    required this.onOperatorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 1.w,
        ),
      ),
      child: triggerType == TriggerType.schedule
          ? TimeSelector(
              selectedTime: selectedTime,
              onTimeSelected: onTimeSelected,
            )
          : SensorTriggerSelector(
              selectedSensorId: selectedSensorId,
              triggerValue: triggerValue,
              selectedOperator: selectedOperator,
              onSensorSelected: onSensorSelected,
              onTriggerValueChanged: onTriggerValueChanged,
              onOperatorChanged: onOperatorChanged,
            ),
    );
  }
}

// Conditions List Widget
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

// Actions List Widget
class ActionsList extends StatelessWidget {
  final List<ActionData> actions;
  final Function(ActionData) onDeleteAction;
  final Function(ActionData, String?) onDeviceIdChanged;
  final Function(ActionData, String?) onStateChanged;
  final Function(ActionData, String?) onTitleChanged;
  final Function(ActionData, String?) onMessageChanged;

  const ActionsList({
    super.key,
    required this.actions,
    required this.onDeleteAction,
    required this.onDeviceIdChanged,
    required this.onStateChanged,
    required this.onTitleChanged,
    required this.onMessageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (actions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Icon(
              Icons.flash_off_outlined,
              size: 48.w,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            SizedBox(height: 12.h),
            Text(
              S.of(context).noActionsAdded,
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
            S.of(context).actions,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 12.h,
            ),
            child: ActionCard(
              action: action,
              onDelete: () => onDeleteAction(action),
              onDeviceIdChanged: (value) => onDeviceIdChanged(action, value),
              onStateChanged: (value) => onStateChanged(action, value),
              onTitleChanged: (value) => onTitleChanged(action, value),
              onMessageChanged: (value) => onMessageChanged(action, value),
            ),
          );
        }).toList(),
      ],
    );
  }
}
