import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/automation/cubit/automation_cubit.dart';
import 'package:tarsheed/src/modules/automation/ui/ui_models/ui_models.dart';
import 'package:tarsheed/src/modules/automation/ui/widgets/actions_components.dart';
import 'package:tarsheed/src/modules/automation/ui/widgets/conditions_components.dart';
import 'package:tarsheed/src/modules/automation/ui/widgets/triggers_components.dart';
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
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: AutomationCubit.get()),
        BlocProvider.value(value: DashboardBloc.get()),
        BlocProvider.value(value: DevicesCubit.get()),
      ],
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: _buildAppBar(theme),
        body: ConnectionWidget(
          onRetry: _loadInitialData,
          child: BlocListener<AutomationCubit, AutomationState>(
            listener: _handleAutomationStateChange,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameSection(theme),
                    SizedBox(height: 24.h),
                    _buildTriggerSection(theme),
                    SizedBox(height: 24.h),
                    _buildConditionsSection(theme),
                    SizedBox(height: 24.h),
                    _buildActionsSection(theme),
                    SizedBox(height: 32.h),
                    _buildSaveButton(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(
        S.of(context).addNewAutomation,
        style: theme.appBarTheme.titleTextStyle?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: theme.appBarTheme.elevation,
      foregroundColor: theme.appBarTheme.foregroundColor,
    );
  }

  void _handleAutomationStateChange(
      BuildContext context, AutomationState state) {
    if (state is AddAutomationSuccess) {
      showToast(S.of(context).automationAddedSuccessfully);
      context.pop();
    } else if (state is AddAutomationError) {
      ExceptionManager.showMessage(state.exception);
    }
  }

  Widget _buildNameSection(ThemeData theme) {
    return AutomationSection(
      title: S.of(context).automationName,
      child: TextFormField(
        controller: _nameController,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: S.of(context).enterAutomationName,
          hintStyle: theme.inputDecorationTheme.hintStyle,
          filled: theme.inputDecorationTheme.filled,
          fillColor: theme.inputDecorationTheme.fillColor,
          border: theme.inputDecorationTheme.border,
          enabledBorder: theme.inputDecorationTheme.enabledBorder,
          focusedBorder: theme.inputDecorationTheme.focusedBorder,
          errorBorder: theme.inputDecorationTheme.errorBorder,
          focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
          contentPadding: theme.inputDecorationTheme.contentPadding,
          prefixIcon: Icon(
            Icons.label_outline,
            color: theme.iconTheme.color,
            size: theme.iconTheme.size,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).automationNameRequired;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTriggerSection(ThemeData theme) {
    return AutomationSection(
      title: S.of(context).trigger,
      subtitle: S.of(context).whenShouldAutomationRun,
      child: Column(
        children: [
          TriggerTypeSelector(
            selectedTriggerType: _selectedTriggerType,
            onTriggerTypeChanged: _handleTriggerTypeChange,
          ),
          SizedBox(height: 16.h),
          TriggerDetails(
            triggerType: _selectedTriggerType,
            selectedTime: _selectedTime,
            selectedSensorId: _selectedSensorId,
            triggerValue: _triggerValue,
            selectedOperator: _selectedOperator,
            onTimeSelected: _handleTimeSelection,
            onSensorSelected: _handleSensorSelection,
            onTriggerValueChanged: _handleTriggerValueChange,
            onOperatorChanged: _handleOperatorChange,
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsSection(ThemeData theme) {
    return AutomationSection(
      title: S.of(context).conditionsOptional,
      subtitle: S.of(context).additionalConditionsDescription,
      child: Column(
        children: [
          ConditionsList(
            conditions: _conditions,
            onDeleteCondition: _handleDeleteCondition,
            onConditionIdChanged: _handleConditionIdChange,
            onConditionStateChanged: _handleConditionStateChange,
            onConditionOperatorChanged: _handleConditionOperatorChange,
          ),
          AddConditionButtons(
            onAddDeviceCondition: _handleAddDeviceCondition,
            onAddSensorCondition: _handleAddSensorCondition,
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(ThemeData theme) {
    return AutomationSection(
      title: S.of(context).actions,
      subtitle: S.of(context).whatShouldHappenDescription,
      child: Column(
        children: [
          ActionsList(
            actions: _actions,
            onDeleteAction: _handleDeleteAction,
            onDeviceIdChanged: _handleActionDeviceIdChange,
            onStateChanged: _handleActionStateChange,
            onTitleChanged: _handleActionTitleChange,
            onMessageChanged: _handleActionMessageChange,
          ),
          AddActionButtons(
            onAddDeviceAction: _handleAddDeviceAction,
            onAddNotificationAction: _handleAddNotificationAction,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
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

  // Event Handlers
  void _handleTriggerTypeChange(TriggerType type) {
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
  }

  void _handleTimeSelection(String? time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _handleSensorSelection(String? sensorId) {
    setState(() {
      _selectedSensorId = sensorId;
    });
  }

  void _handleTriggerValueChange(int? value) {
    setState(() {
      _triggerValue = value;
    });
  }

  void _handleOperatorChange(String? operator) {
    setState(() {
      _selectedOperator = operator;
    });
  }

  void _handleDeleteCondition(ConditionData condition) {
    setState(() {
      _conditions.remove(condition);
    });
  }

  void _handleConditionIdChange(ConditionData condition, String? id) {
    setState(() {
      condition.id = id;
    });
  }

  void _handleConditionStateChange(ConditionData condition, dynamic state) {
    setState(() {
      condition.state = state;
    });
  }

  void _handleConditionOperatorChange(
      ConditionData condition, String operator) {
    setState(() {
      condition.operator = operator;
    });
  }

  void _handleAddDeviceCondition() {
    setState(() {
      _conditions.add(ConditionData(type: ConditionType.device));
    });
  }

  void _handleAddSensorCondition() {
    setState(() {
      _conditions.add(ConditionData(type: ConditionType.sensor));
    });
  }

  void _handleDeleteAction(ActionData action) {
    setState(() {
      _actions.remove(action);
    });
  }

  void _handleActionDeviceIdChange(ActionData action, String? value) {
    setState(() {
      action.deviceId = value;
    });
  }

  void _handleActionStateChange(ActionData action, dynamic value) {
    setState(() {
      action.state = value;
    });
  }

  void _handleActionTitleChange(ActionData action, String? value) {
    setState(() {
      action.title = value;
    });
  }

  void _handleActionMessageChange(ActionData action, String? value) {
    setState(() {
      action.message = value;
    });
  }

  void _handleAddDeviceAction() {
    setState(() {
      _actions.add(ActionData(type: ActionType.device));
    });
  }

  void _handleAddNotificationAction() {
    setState(() {
      _actions.add(ActionData(type: ActionType.notification));
    });
  }

  void _saveAutomation() {
    if (!_formKey.currentState!.validate()) return;

    final theme = Theme.of(context);

    if (_actions.isEmpty) {
      _showValidationSnackBar(
        S.of(context).pleaseAddAtLeastOneAction,
        theme.colorScheme.secondary,
      );
      return;
    }

    if (_selectedTriggerType == TriggerType.schedule && _selectedTime == null) {
      _showValidationSnackBar(
        S.of(context).pleaseSelectTimeForSchedule,
        theme.colorScheme.secondary,
      );
      return;
    }

    if (_selectedTriggerType == TriggerType.sensor &&
        (_selectedSensorId == null ||
            _triggerValue == null ||
            _selectedOperator == null)) {
      _showValidationSnackBar(
        S.of(context).pleaseConfigureSensorTrigger,
        theme.colorScheme.secondary,
      );
      return;
    }

    final automation = _createAutomation();
    AutomationCubit.get().addAutomation(automation);
  }

  void _showValidationSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).snackBarTheme.contentTextStyle,
        ),
        backgroundColor: backgroundColor,
        behavior: Theme.of(context).snackBarTheme.behavior,
        shape: Theme.of(context).snackBarTheme.shape,
      ),
    );
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
