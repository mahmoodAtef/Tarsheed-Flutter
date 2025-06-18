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

class EditAutomationScreen extends StatefulWidget {
  final Automation automation;

  const EditAutomationScreen({
    super.key,
    required this.automation,
  });

  @override
  State<EditAutomationScreen> createState() => _EditAutomationScreenState();
}

class _EditAutomationScreenState extends State<EditAutomationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _selectedOperator;

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
    _loadInitialData();
    _initializeFormData();
  }

  void _loadInitialData() {
    DashboardBloc.get().add(GetSensorsEvent());
    DevicesCubit.get().getDevices();
  }

  void _initializeFormData() {
    // Initialize name
    _nameController = TextEditingController(text: widget.automation.name);

    // Initialize trigger
    _initializeTrigger();

    // Initialize conditions
    _initializeConditions();

    // Initialize actions
    _initializeActions();
  }

  void _initializeTrigger() {
    final trigger = widget.automation.trigger;
    if (trigger is ScheduleTrigger) {
      _selectedTriggerType = TriggerType.schedule;
      _selectedTime = trigger.time;
    } else if (trigger is SensorTrigger) {
      _selectedTriggerType = TriggerType.sensor;
      _selectedSensorId = trigger.sensorID;
      _triggerValue = trigger.value;
      _selectedOperator = trigger.operator; // إضافة هذا السطر
    }
  }

  void _initializeConditions() {
    _conditions = widget.automation.conditions.map((condition) {
      if (condition is DeviceCondition) {
        return ConditionData(type: ConditionType.device)
          ..id = condition.deviceID
          ..state = condition.state;
      } else if (condition is SensorCondition) {
        return ConditionData(type: ConditionType.sensor)
          ..id = condition.sensorID
          ..state = condition.state
          ..operator =
              condition.operator ?? '='; // Initialize operator with fallback
      }
      // Fallback
      return ConditionData(type: ConditionType.device);
    }).toList();
  }

  void _initializeActions() {
    _actions = widget.automation.actions.map((action) {
      if (action is DeviceAction) {
        return ActionData(type: ActionType.device)
          ..deviceId = action.deviceId
          ..state = action.state;
      } else if (action is NotificationAction) {
        return ActionData(type: ActionType.notification)
          ..title = action.title
          ..message = action.message;
      }
      // Fallback
      return ActionData(type: ActionType.device);
    }).toList();
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
            S.of(context).editAutomation, // Add this to your localization
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: ColorManager.white,
          elevation: 1,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () => _showDeleteConfirmation(),
              icon: Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
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
              } else if (state is DeleteAutomationSuccess) {
                showToast(S.of(context).automationDeletedSuccessfully);
                context.pop();
              } else if (state is DeleteAutomationError) {
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
                  _selectedOperator = null; // إضافة هذا السطر
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
            selectedOperator: _selectedOperator, // إضافة هذا السطر
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
              // إضافة هذا الـ callback
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
              // New callback
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
          SizedBox(height: 16.h),
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

  Widget _buildUpdateButton() {
    return BlocBuilder<AutomationCubit, AutomationState>(
      builder: (context, state) {
        final isLoading = state is UpdateAutomationLoading;

        return AutomationSaveButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : _updateAutomation,
          buttonText: S.of(context).updateAutomation,
        );
      },
    );
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

      final automation = _createUpdatedAutomation();
      AutomationCubit.get().updateAutomation(automation);
    }
  }

// تحديث دالة _createUpdatedAutomation()
  Automation _createUpdatedAutomation() {
    // Create trigger
    Trigger trigger;
    if (_selectedTriggerType == TriggerType.schedule) {
      trigger = ScheduleTrigger(time: _selectedTime!);
    } else {
      trigger = SensorTrigger(
        sensorID: _selectedSensorId!,
        value: _triggerValue!,
        operator: _selectedOperator!, // إضافة الـ operator
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

    return widget.automation.copyWith(
      name: _nameController.text,
      trigger: trigger,
      conditions: conditions,
      actions: actions,
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).deleteAutomation),
          content: Text(S.of(context).deleteAutomationConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            BlocBuilder<AutomationCubit, AutomationState>(
              builder: (context, state) {
                final isDeleting = state is DeleteAutomationLoading;

                return TextButton(
                  onPressed: isDeleting
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          AutomationCubit.get()
                              .deleteAutomation(widget.automation.id!);
                        },
                  child: isDeleting
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          S.of(context).delete,
                          style: TextStyle(color: Colors.red),
                        ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
