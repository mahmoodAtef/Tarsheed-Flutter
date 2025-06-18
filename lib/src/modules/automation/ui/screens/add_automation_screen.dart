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
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

import '../../data/models/action/action.dart';
import '../../data/models/automation.dart';
import '../../data/models/condition/condition.dart';
import '../../data/models/trigger/trigger.dart';
import '../widgets/components.dart';

class AddAutomationScreen extends StatefulWidget {
  const AddAutomationScreen({super.key});

  @override
  State<AddAutomationScreen> createState() => _AddAutomationScreenState();
}

class _AddAutomationScreenState extends State<AddAutomationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  // Trigger
  TriggerType _selectedTriggerType = TriggerType.schedule;
  String? _selectedTime;
  String? _selectedSensorId;
  int? _triggerValue;
  String? _selectedOperator;

  List<ConditionData> _conditions = [];
  List<ActionData> _actions = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
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
        BlocProvider.value(value: AutomationCubit.get()),
        BlocProvider.value(value: DashboardBloc.get()),
        BlocProvider.value(value: DevicesCubit.get()),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            S.of(context).addNewAutomation,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: ColorManager.white,
          elevation: 1,
          foregroundColor: Colors.black,
        ),
        body: ConnectionWidget(
          onRetry: _loadInitialData,
          child: BlocListener<AutomationCubit, AutomationState>(
            listener: (context, state) {
              if (state is AddAutomationSuccess) {
                showToast(S.of(context).automationAddedSuccessfully);
                context.pop();
              } else if (state is AddAutomationError) {
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
                    _buildNameSection(),
                    SizedBox(height: 24.h),
                    _buildTriggerSection(),
                    SizedBox(height: 24.h),
                    _buildConditionsSection(),
                    SizedBox(height: 24.h),
                    _buildActionsSection(),
                    SizedBox(height: 32.h),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return AutomationSection(
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
    return AutomationSection(
      title: S.of(context).trigger,
      subtitle: S.of(context).whenShouldAutomationRun,
      child: Column(
        children: [
          TriggerTypeSelector(
            selectedTriggerType: _selectedTriggerType,
            onTriggerTypeChanged: (type) {
              setState(() {
                _selectedTriggerType = type;
                if (type == TriggerType.schedule) {
                  _selectedSensorId = null;
                  _triggerValue = null;
                  _selectedOperator = null;
                } else {
                  _selectedTime = null;
                }
              });
            },
          ),
          SizedBox(height: 16.h),
          TriggerDetails(
            triggerType: _selectedTriggerType,
            selectedTime: _selectedTime,
            selectedSensorId: _selectedSensorId,
            triggerValue: _triggerValue,
            selectedOperator: _selectedOperator,
            onTimeSelected: (time) {
              setState(() {
                _selectedTime = time;
              });
            },
            onSensorSelected: (sensorId) {
              setState(() {
                _selectedSensorId = sensorId;
              });
            },
            onTriggerValueChanged: (value) {
              setState(() {
                _triggerValue = value;
              });
            },
            onOperatorChanged: (operator) {
              setState(() {
                _selectedOperator = operator;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsSection() {
    return AutomationSection(
      title: S.of(context).conditionsOptional,
      subtitle: S.of(context).additionalConditions,
      child: Column(
        children: [
          ConditionsList(
            conditions: _conditions,
            onDeleteCondition: (condition) {
              setState(() {
                _conditions.remove(condition);
              });
            },
            onConditionIdChanged: (condition, id) {
              setState(() {
                condition.id = id;
              });
            },
            onConditionStateChanged: (condition, state) {
              setState(() {
                condition.state = state;
              });
            },
            onConditionOperatorChanged: (condition, operator) {
              setState(() {
                condition.operator = operator;
              });
            },
          ),
          AddConditionButtons(
            onAddDeviceCondition: () => setState(() {
              _conditions.add(ConditionData(type: ConditionType.device));
            }),
            onAddSensorCondition: () => setState(() {
              _conditions.add(ConditionData(type: ConditionType.sensor));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return AutomationSection(
      title: S.of(context).actions,
      subtitle: S.of(context).whatShouldHappen,
      child: Column(
        children: [
          ActionsList(
            actions: _actions,
            onDeleteAction: (action) {
              setState(() {
                _actions.remove(action);
              });
            },
            onDeviceIdChanged: (action, value) {
              setState(() {
                action.deviceId = value;
              });
            },
            onStateChanged: (action, value) {
              setState(() {
                action.state = value;
              });
            },
            onTitleChanged: (action, value) {
              setState(() {
                action.title = value;
              });
            },
            onMessageChanged: (action, value) {
              setState(() {
                action.message = value;
              });
            },
          ),
          AddActionButtons(
            onAddDeviceAction: () => setState(() {
              _actions.add(ActionData(type: ActionType.device));
            }),
            onAddNotificationAction: () => setState(() {
              _actions.add(ActionData(type: ActionType.notification));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<AutomationCubit, AutomationState>(
      builder: (context, state) {
        final isLoading = state is AddAutomationLoading;

        return AutomationSaveButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : _saveAutomation,
          buttonText: S.of(context).saveAutomation,
        );
      },
    );
  }

  void _saveAutomation() {
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
          (_selectedSensorId == null ||
              _triggerValue == null ||
              _selectedOperator == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).pleaseConfigureSensorTrigger),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final automation = _createAutomation();
      AutomationCubit.get().addAutomation(automation);
    }
  }

  Automation _createAutomation() {
    // Create trigger
    Trigger trigger;
    if (_selectedTriggerType == TriggerType.schedule) {
      trigger = ScheduleTrigger(time: _selectedTime!);
    } else {
      trigger = SensorTrigger(
        sensorID: _selectedSensorId!,
        value: _triggerValue!,
        operator: _selectedOperator!,
      );
    }

    // Create conditions
    List<Condition> conditions = _conditions.map((conditionData) {
      if (conditionData.type == ConditionType.device) {
        return DeviceCondition(
          deviceID: conditionData.id!,
          state: conditionData.state,
        );
      } else {
        return SensorCondition(
          sensorID: conditionData.id!,
          state: conditionData.state,
          operator: conditionData.operator,
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

    return Automation(
      name: _nameController.text,
      trigger: trigger,
      conditions: conditions,
      actions: actions,
    );
  }
}
