// automation_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 4.h),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : ColorManager.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.blue : Colors.grey.shade600,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
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
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.blue),
            SizedBox(width: 12.w),
            Text(
              selectedTime ?? S.of(context).selectTime,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight:
                    selectedTime != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
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
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          current is GetSensorsSuccessState ||
          current is GetSensorsLoadingState ||
          current is GetSensorsErrorState,
      builder: (context, state) {
        if (state is GetSensorsLoadingState) {
          return const Center(child: CircularProgressIndicator());
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
                filled: true,
                fillColor: ColorManager.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.sensors),
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
                filled: true,
                fillColor: ColorManager.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.compare_arrows),
              ),
              items: _buildOperatorItems(context),
              onChanged: onOperatorChanged,
            ),
            SizedBox(height: 12.h),

            // Trigger Value
            TextFormField(
              decoration: InputDecoration(
                labelText: S.of(context).triggerValue,
                filled: true,
                fillColor: ColorManager.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.numbers),
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
            SizedBox(width: 8),
            Text('=='),
          ],
        ),
      ),
      DropdownMenuItem(
        value: '>',
        child: Row(
          children: [
            SizedBox(width: 8),
            Text('>'),
          ],
        ),
      ),
      DropdownMenuItem(
        value: '<',
        child: Row(
          children: [
            SizedBox(width: 8),
            Text('<'),
          ],
        ),
      ),
      DropdownMenuItem(
        value: '>=',
        child: Row(
          children: [
            SizedBox(width: 8),
            Text('>='),
          ],
        ),
      ),
      DropdownMenuItem(
        value: '<=',
        child: Row(
          children: [
            SizedBox(width: 8),
            Text('<='),
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
  final Function(String) onOperatorChanged; // New callback for operator

  const ConditionCard({
    super.key,
    required this.condition,
    required this.onDelete,
    required this.onIdChanged,
    required this.onStateChanged,
    required this.onOperatorChanged, // Add required parameter
  });

  @override
  Widget build(BuildContext context) {
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
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        condition.type == ConditionType.device
                            ? Icons.devices
                            : Icons.sensors,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          condition.type == ConditionType.device
                              ? S.of(context).deviceCondition
                              : S.of(context).sensorCondition,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.sp),
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.red),
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
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
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
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
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
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
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
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
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
      DropdownMenuItem(
        value: '=',
        child: Text('='),
      ),
      DropdownMenuItem(
        value: '>',
        child: Text('>'),
      ),
      DropdownMenuItem(
        value: '<',
        child: Text('<'),
      ),
      DropdownMenuItem(
        value: '>=',
        child: Text('>='),
      ),
      DropdownMenuItem(
        value: '<=',
        child: Text('<='),
      ),
    ];
  }
}

// 9. Action Card Widget
// Fix for ActionCard widget - replace the existing ActionCard in your components.dart

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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  color: ColorManager.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  action.type == ActionType.device
                      ? S.of(context).deviceAction
                      : S.of(context).notificationAction,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
    return Column(
      children: [
        // Device Selector
        BlocBuilder<DevicesCubit, DevicesState>(
          builder: (context, state) {
            if (state is GetDevicesSuccess) {
              // Create unique device options
              final devices = state.devices;
              final deviceItems = devices?.map((device) {
                return DropdownMenuItem<String>(
                  value: device.id,
                  child: Text(device.name),
                );
              }).toList();

              // Ensure the selected value exists in the list
              String? validSelectedValue = action.deviceId;
              if (validSelectedValue != null &&
                  !devices!.any((device) => device.id == validSelectedValue)) {
                validSelectedValue = null;
                // Reset the invalid value
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onDeviceIdChanged('');
                });
              }

              return DropdownButtonFormField<String>(
                key: ValueKey('device_${action.hashCode}'),
                value: validSelectedValue,
                decoration: InputDecoration(
                  labelText: S.of(context).selectDevice,
                  filled: true,
                  fillColor: ColorManager.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
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
            return const CircularProgressIndicator();
          },
        ),
        SizedBox(height: 16.h),

        // State Selector
        DropdownButtonFormField<String>(
          key: ValueKey('state_${action.hashCode}'),
          value: _getValidStateValue(),
          decoration: InputDecoration(
            labelText: S.of(context).deviceState,
            filled: true,
            fillColor: ColorManager.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
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
    return Column(
      children: [
        TextFormField(
          key: ValueKey('title_${action.hashCode}'),
          initialValue: action.title,
          decoration: InputDecoration(
            labelText: S.of(context).notificationTitle,
            filled: true,
            fillColor: ColorManager.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.title),
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
            filled: true,
            fillColor: ColorManager.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.message),
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
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: ColorManager.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: ColorManager.white)
            : Text(
                buttonText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

// 13. Trigger Details Widget (combines time and sensor selectors)
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
    if (triggerType == TriggerType.schedule) {
      return TimeSelector(
        selectedTime: selectedTime,
        onTimeSelected: onTimeSelected,
      );
    } else {
      return SensorTriggerSelector(
        selectedSensorId: selectedSensorId,
        triggerValue: triggerValue,
        selectedOperator: selectedOperator,
        onSensorSelected: onSensorSelected,
        onTriggerValueChanged: onTriggerValueChanged,
        onOperatorChanged: onOperatorChanged,
      );
    }
  }
}

// 14. Conditions List Widget
class ConditionsList extends StatelessWidget {
  final List<ConditionData> conditions;
  final Function(ConditionData) onDeleteCondition;
  final Function(ConditionData, String?) onConditionIdChanged;
  final Function(ConditionData, int) onConditionStateChanged;
  final Function(ConditionData, String)
      onConditionOperatorChanged; // New callback

  const ConditionsList({
    super.key,
    required this.conditions,
    required this.onDeleteCondition,
    required this.onConditionIdChanged,
    required this.onConditionStateChanged,
    required this.onConditionOperatorChanged, // Add required parameter
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: conditions
          .map((condition) => ConditionCard(
                condition: condition,
                onDelete: () => onDeleteCondition(condition),
                onIdChanged: (value) => onConditionIdChanged(condition, value),
                onStateChanged: (value) =>
                    onConditionStateChanged(condition, value),
                onOperatorChanged: (value) => onConditionOperatorChanged(
                    condition, value), // Add callback
              ))
          .toList(),
    );
  }
}

// 15. Actions List Widget
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
    return Column(
      children: actions
          .map((action) => ActionCard(
                action: action,
                onDelete: () => onDeleteAction(action),
                onDeviceIdChanged: (value) => onDeviceIdChanged(action, value),
                onStateChanged: (value) => onStateChanged(action, value),
                onTitleChanged: (value) => onTitleChanged(action, value),
                onMessageChanged: (value) => onMessageChanged(action, value),
              ))
          .toList(),
    );
  }
}
