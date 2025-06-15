import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/automation/cubit/automation_cubit.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/add_automation_screen.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';

import '../../data/models/action/action.dart';
import '../../data/models/automation.dart';
import '../../data/models/condition/condition.dart';
import '../../data/models/trigger/trigger.dart';

class EditAutomationScreen extends StatefulWidget {
  final Automation automation;

  const EditAutomationScreen({super.key, required this.automation});

  @override
  State<EditAutomationScreen> createState() => _EditAutomationScreenState();
}

class _EditAutomationScreenState extends State<EditAutomationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  // Trigger
  late TriggerType _selectedTriggerType;
  String? _selectedTime;
  String? _selectedSensorId;
  int? _triggerValue;

  List<ConditionData> _conditions = [];
  List<ActionData> _actions = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadAutomationData();
    _loadInitialData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.automation.name);
  }

  void _loadAutomationData() {
    // Load trigger data
    if (widget.automation.trigger is ScheduleTrigger) {
      _selectedTriggerType = TriggerType.schedule;
      _selectedTime = (widget.automation.trigger as ScheduleTrigger).time;
    } else if (widget.automation.trigger is SensorTrigger) {
      _selectedTriggerType = TriggerType.sensor;
      final sensorTrigger = widget.automation.trigger as SensorTrigger;
      _selectedSensorId = sensorTrigger.sensorID;
      _triggerValue = sensorTrigger.value;
    } else {
      _selectedTriggerType = TriggerType.schedule;
    }

    // Load conditions data
    _conditions = widget.automation.conditions.map((condition) {
      if (condition is DeviceCondition) {
        return ConditionData(type: ConditionType.device)
          ..id = condition.deviceID
          ..state = condition.state;
      } else if (condition is SensorCondition) {
        return ConditionData(type: ConditionType.sensor)
          ..id = condition.sensorID
          ..state = condition.state;
      } else {
        return ConditionData(type: ConditionType.device);
      }
    }).toList();

    // Load actions data
    _actions = widget.automation.actions.map((action) {
      if (action is DeviceAction) {
        return ActionData(type: ActionType.device)
          ..deviceId = action.deviceId
          ..state = action.state;
      } else if (action is NotificationAction) {
        return ActionData(type: ActionType.notification)
          ..title = action.title
          ..message = action.message;
      } else {
        return ActionData(type: ActionType.device);
      }
    }).toList();
  }

  void _loadInitialData() {
    DashboardBloc.get().add(GetSensorsEvent());
    DevicesCubit.get().getDevices();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AutomationCubit.get()),
        BlocProvider.value(value: DashboardBloc.get()),
        BlocProvider.value(value: DevicesCubit.get()),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            S.of(context).editAutomation,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: ColorManager.white,
          elevation: 1,
          foregroundColor: Colors.black,
        ),
        body: ConnectionWidget(
          onRetry: _loadInitialData,
          child: BlocListener<AutomationCubit, AutomationState>(
            listener: (context, state) {
              if (state is UpdateAutomationSuccess) {
                showToast(S.of(context).automationUpdatedSuccessfully);
                context.pop();
              } else if (state is UpdateAutomationError) {
                ExceptionManager.showMessage(state.exception);
              }
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(),
                    SizedBox(height: 24.h),
                    _buildNameSection(),
                    SizedBox(height: 24.h),
                    _buildTriggerSection(),
                    SizedBox(height: 24.h),
                    _buildConditionsSection(),
                    SizedBox(height: 24.h),
                    _buildActionsSection(),
                    SizedBox(height: 32.h),
                    _buildUpdateButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 24),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              S.of(context).editingAutomationInfo,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection() {
    return _buildSection(
      title: S.of(context).automationName,
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: S.of(context).enterAutomationName,
          filled: true,
          fillColor: ColorManager.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.label_outline),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).enterAutomationName;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTriggerSection() {
    return _buildSection(
      title: S.of(context).trigger,
      subtitle: S.of(context).whenShouldAutomationRun,
      child: Column(
        children: [
          _buildTriggerTypeSelector(),
          SizedBox(height: 16.h),
          _buildTriggerDetails(),
        ],
      ),
    );
  }

  Widget _buildTriggerTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildSelectableCard(
            title: S.of(context).schedule,
            subtitle: S.of(context).runAtSpecificTime,
            icon: Icons.schedule,
            isSelected: _selectedTriggerType == TriggerType.schedule,
            onTap: () => setState(() {
              _selectedTriggerType = TriggerType.schedule;
              _selectedSensorId = null;
              _triggerValue = null;
            }),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSelectableCard(
            title: S.of(context).sensor,
            subtitle: S.of(context).runWhenSensorValueChanges,
            icon: Icons.sensors,
            isSelected: _selectedTriggerType == TriggerType.sensor,
            onTap: () => setState(() {
              _selectedTriggerType = TriggerType.sensor;
              _selectedTime = null;
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTriggerDetails() {
    if (_selectedTriggerType == TriggerType.schedule) {
      return _buildTimeSelector();
    } else {
      return _buildSensorTriggerSelector();
    }
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? initialTime;
        if (_selectedTime != null) {
          final parts = _selectedTime!.split(':');
          initialTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        } else {
          initialTime = TimeOfDay.now();
        }

        final time = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );
        if (time != null) {
          setState(() {
            _selectedTime =
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          });
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
              _selectedTime ?? S.of(context).selectTime,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight:
                    _selectedTime != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTriggerSelector() {
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
        final sensorItems = _buildSensorItems(sensors);

        return Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSensorId,
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
              onChanged: (value) => setState(() => _selectedSensorId = value),
            ),
            SizedBox(height: 12.h),
            TextFormField(
              initialValue: _triggerValue?.toString(),
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
              onChanged: (value) => _triggerValue = int.tryParse(value),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConditionsSection() {
    return _buildSection(
      title: S.of(context).conditionsOptional,
      subtitle: S.of(context).additionalConditions,
      child: Column(
        children: [
          ..._conditions
              .map((condition) => _buildConditionCard(condition))
              .toList(),
          _buildAddConditionButton(),
        ],
      ),
    );
  }

  Widget _buildConditionCard(ConditionData condition) {
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
                        onPressed: () =>
                            setState(() => _conditions.remove(condition)),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
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
                              ? _buildDeviceItems(devices)
                              : _buildSensorItems(sensors),
                          onChanged: (value) =>
                              setState(() => condition.id = value),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
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
                                onChanged: (value) => setState(
                                    () => condition.state = value ?? 0),
                              )
                            : TextFormField(
                                initialValue: condition.state.toString(),
                                decoration: InputDecoration(
                                  labelText: S.of(context).stateValue,
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) =>
                                    condition.state = int.tryParse(value) ?? 0,
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

  Widget _buildAddConditionButton() {
    return Row(
      children: [
        Expanded(
          child: _buildAddButton(
            title: S.of(context).addDeviceCondition,
            icon: Icons.devices,
            onTap: () => setState(() {
              _conditions.add(ConditionData(type: ConditionType.device));
            }),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildAddButton(
            title: S.of(context).addSensorCondition,
            icon: Icons.sensors,
            onTap: () => setState(() {
              _conditions.add(ConditionData(type: ConditionType.sensor));
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return _buildSection(
      title: S.of(context).actions,
      subtitle: S.of(context).whatShouldHappen,
      child: Column(
        children: [
          ..._actions.map((action) => _buildActionCard(action)).toList(),
          _buildAddActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionCard(ActionData action) {
    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (context, devicesState) {
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
                    action.type == ActionType.device
                        ? Icons.devices
                        : Icons.notifications,
                    color: Colors.green,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      action.type == ActionType.device
                          ? S.of(context).deviceAction
                          : S.of(context).notificationAction,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16.sp),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _actions.remove(action)),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              if (action.type == ActionType.device) ...[
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: action.deviceId,
                        decoration: InputDecoration(
                          labelText: S.of(context).selectDevice,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _buildDeviceItems(devices),
                        onChanged: (value) =>
                            setState(() => action.deviceId = value),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        // Fix: تأكد من أن القيمة صحيحة أو null
                        value: (action.state == "ON" || action.state == "OFF")
                            ? action.state
                            : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).action,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: "ON", child: Text(S.of(context).turnOn)),
                          DropdownMenuItem(
                              value: "OFF", child: Text(S.of(context).turnOff)),
                        ],
                        onChanged: (value) =>
                            setState(() => action.state = value),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                TextFormField(
                  initialValue: action.title,
                  decoration: InputDecoration(
                    labelText: S.of(context).notificationTitle,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => action.title = value,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  initialValue: action.message,
                  decoration: InputDecoration(
                    labelText: S.of(context).notificationMessage,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 2,
                  onChanged: (value) => action.message = value,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddActionButton() {
    return Row(
      children: [
        Expanded(
          child: _buildAddButton(
            title: S.of(context).addDeviceAction,
            icon: Icons.devices,
            onTap: () => setState(() {
              _actions.add(ActionData(type: ActionType.device));
            }),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildAddButton(
            title: S.of(context).addNotification,
            icon: Icons.notifications,
            onTap: () => setState(() {
              _actions.add(ActionData(type: ActionType.notification));
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return BlocBuilder<AutomationCubit, AutomationState>(
      builder: (context, state) {
        final isLoading = state is UpdateAutomationLoading;

        return SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : _updateAutomation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: ColorManager.white)
                : Text(
                    S.of(context).updateAutomation,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
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
            subtitle,
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

  Widget _buildSelectableCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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

  Widget _buildAddButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
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

  // Helper methods to build dropdown items
  List<DropdownMenuItem<String>> _buildDeviceItems(List<Device> devices) {
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

  List<DropdownMenuItem<String>> _buildSensorItems(List<Sensor> sensors) {
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

  void _updateAutomation() {
    if (_formKey.currentState!.validate()) {
      if (_actions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).pleaseAddAtLeastOneAction),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_selectedTriggerType == TriggerType.schedule &&
          _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).pleaseSelectTimeForSchedule),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_selectedTriggerType == TriggerType.sensor &&
          (_selectedSensorId == null || _triggerValue == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).pleaseConfigureSensorTrigger),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final updatedAutomation = _createUpdatedAutomation();
      AutomationCubit.get().updateAutomation(updatedAutomation);
    }
  }

  Automation _createUpdatedAutomation() {
    // Create trigger
    Trigger trigger;
    if (_selectedTriggerType == TriggerType.schedule) {
      trigger = ScheduleTrigger(time: _selectedTime!);
    } else {
      trigger = SensorTrigger(
        sensorID: _selectedSensorId!,
        value: _triggerValue!,
      );
    }
    // Create conditions
    List<Condition> conditions = _conditions.map((conditionData) {
      if (conditionData.type == ConditionType.device) {
        return DeviceCondition(
          deviceID: conditionData.id!,
          state: conditionData.state ?? 0,
        );
      } else {
        return SensorCondition(
          sensorID: conditionData.id!,
          state: conditionData.state ?? 0,
        );
      }
    }).toList();
    // Create actions
    List<AutomationAction> actions = _actions.map((actionData) {
      if (actionData.type == ActionType.device) {
        return DeviceAction(
          deviceId: actionData.deviceId!,
          state: actionData.state!,
        );
      } else {
        return NotificationAction(
          title: actionData.title!,
          message: actionData.message!,
        );
      }
    }).toList();
    // Create updated automation
    return widget.automation.copyWith(
      name: _nameController.text,
      trigger: trigger,
      conditions: conditions,
      actions: actions,
    );
  }
}
