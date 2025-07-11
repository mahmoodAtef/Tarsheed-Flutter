import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/automation/cubit/automation_cubit.dart';
import 'package:tarsheed/src/modules/automation/data/models/action/action.dart';
import 'package:tarsheed/src/modules/automation/data/models/automation.dart';
import 'package:tarsheed/src/modules/automation/data/models/condition/condition.dart';
import 'package:tarsheed/src/modules/automation/data/models/trigger/trigger.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/edit_automation_screen.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

class AutomationDetailsScreen extends StatefulWidget {
  final Automation automation;

  const AutomationDetailsScreen({
    super.key,
    required this.automation,
  });

  @override
  State<AutomationDetailsScreen> createState() =>
      _AutomationDetailsScreenState();
}

class _AutomationDetailsScreenState extends State<AutomationDetailsScreen> {
  late Automation _currentAutomation;
  bool _isChangingStatus = false;

  @override
  void initState() {
    super.initState();
    _currentAutomation = widget.automation;
    _loadData();
  }

  void _loadData() {
    DashboardBloc.get().add(GetSensorsEvent());
    sl<DevicesCubit>().getDevices();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: DashboardBloc.get()),
        BlocProvider.value(value: DevicesCubit.get()),
      ],
      child: BlocListener<AutomationCubit, AutomationState>(
        listener: (context, state) {
          _handleAutomationStateChanges(state);
        },
        child: Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            title: Text(
              _currentAutomation.name,
              style: theme.appBarTheme.titleTextStyle,
            ),
            actions: [
              IconButton(
                onPressed: _editAutomation,
                icon: const Icon(Icons.edit),
                tooltip: S.of(context).edit,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteDialog();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: theme.colorScheme.error),
                        SizedBox(width: 8.w),
                        Text(S.of(context).delete),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: ConnectionWidget(
            onRetry: _loadData,
            child: BlocBuilder<AutomationCubit, AutomationState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(state),
                      SizedBox(height: 16.h),
                      _buildTriggerSection(),
                      SizedBox(height: 16.h),
                      _buildConditionsSection(),
                      SizedBox(height: 16.h),
                      _buildActionsSection(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleAutomationStateChanges(AutomationState state) {
    if (state is ChangeAutomationStatusSuccess) {
      setState(() {
        _isChangingStatus = false;
        // Update the current automation with the new status
        final updatedAutomation = state.automations?.firstWhere(
          (automation) => automation.id == _currentAutomation.id,
          orElse: () => _currentAutomation,
        );
        if (updatedAutomation != null) {
          _currentAutomation = updatedAutomation;
        }
      });

      showToast(
        S.of(context).automationStatusChanged,
      );
    } else if (state is ChangeAutomationStatusError) {
      setState(() {
        _isChangingStatus = false;
      });
      ExceptionManager.showMessage(state.exception);
    } else if (state is ChangeAutomationStatusLoading) {
      setState(() {
        _isChangingStatus = true;
      });
    } else if (state is DeleteAutomationSuccess) {
      showToast(S.of(context).automationDeletedSuccessfully);
      context.pop();
    } else if (state is DeleteAutomationError) {
      ExceptionManager.showMessage(state.exception);
    }
  }

  Widget _buildStatusCard(AutomationState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool isLoading =
        _isChangingStatus || state is ChangeAutomationStatusLoading;
    final statusColor = _currentAutomation.isEnabled
        ? theme.colorScheme.secondary
        : theme.iconTheme.color!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(statusColor),
                        ),
                      )
                    : Icon(
                        _currentAutomation.isEnabled
                            ? Icons.play_circle_filled
                            : Icons.pause_circle_filled,
                        color: statusColor,
                        size: 24.sp,
                      ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).automationStatus,
                      style: theme.textTheme.bodySmall,
                    ),
                    Row(
                      children: [
                        Text(
                          _currentAutomation.isEnabled
                              ? S.of(context).enabled
                              : S.of(context).disabled,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: statusColor,
                          ),
                        ),
                        if (isLoading) ...[
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.iconTheme.color!,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: _currentAutomation.isEnabled,
                onChanged:
                    isLoading ? null : (value) => _toggleAutomationStatus(),
              ),
            ],
          ),
          if (isLoading) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    S.of(context).updatingStatus,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTriggerSection() {
    return _buildSection(
      title: S.of(context).trigger,
      subtitle: S.of(context).whenShouldAutomationRun,
      child: _buildTriggerCard(),
    );
  }

  Widget _buildTriggerCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData icon;
    String title;
    String subtitle;
    Color color;

    if (_currentAutomation.trigger is ScheduleTrigger) {
      final scheduleTrigger = _currentAutomation.trigger as ScheduleTrigger;
      icon = Icons.schedule;
      title = S.of(context).schedule;
      subtitle = '${S.of(context).runAtSpecificTime}: ${scheduleTrigger.time}';
      color = colorScheme.primary;
    } else if (_currentAutomation.trigger is SensorTrigger) {
      final sensorTrigger = _currentAutomation.trigger as SensorTrigger;
      icon = Icons.sensors;
      title = S.of(context).sensor;
      subtitle = '${S.of(context).sensorValue}: ${sensorTrigger.value}';
      color = Color(0xFFFF9800); // Using warningOrange from theme
    } else {
      icon = Icons.help;
      title = S.of(context).unknown;
      subtitle = '';
      color = theme.iconTheme.color!;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_currentAutomation.conditions.isEmpty) {
      return _buildSection(
        title: S.of(context).conditions,
        subtitle: S.of(context).noConditionsSet,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: theme.iconTheme.color),
              SizedBox(width: 12.w),
              Text(
                S.of(context).noConditionsSet,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return _buildSection(
      title: S.of(context).conditions,
      subtitle: S.of(context).additionalConditions,
      child: Column(
        children: _currentAutomation.conditions
            .map((condition) => _buildConditionCard(condition))
            .toList(),
      ),
    );
  }

  Widget _buildConditionCard(Condition condition) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData icon;
    String title;
    String subtitle;
    Color color;

    if (condition is DeviceCondition) {
      icon = Icons.devices;
      title = S.of(context).deviceCondition;
      subtitle =
          '${S.of(context).state}: ${condition.state == 1 ? S.of(context).turnOn : S.of(context).turnOff}';
      color = const Color(0xFF9C27B0); // Purple color
    } else if (condition is SensorCondition) {
      icon = Icons.sensors;
      title = S.of(context).sensorCondition;
      subtitle = '${S.of(context).value}: ${condition.state}';
      color = const Color(0xFF009688); // Teal color
    } else {
      icon = Icons.help;
      title = S.of(context).unknown;
      subtitle = '';
      color = theme.iconTheme.color!;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return _buildSection(
      title: S.of(context).actions,
      subtitle: S.of(context).whatShouldHappen,
      child: Column(
        children: _currentAutomation.actions
            .map((action) => _buildActionCard(action))
            .toList(),
      ),
    );
  }

  Widget _buildActionCard(AutomationAction action) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData icon;
    String title;
    String subtitle;
    Color color;

    if (action is DeviceAction) {
      icon = Icons.devices;
      title = S.of(context).deviceAction;
      subtitle =
          '${S.of(context).state}: ${action.state == "turn_on" ? S.of(context).turnOn : S.of(context).turnOff}';
      color = colorScheme.secondary;
    } else if (action is NotificationAction) {
      icon = Icons.notifications;
      title = S.of(context).notificationAction;
      subtitle = '${action.title}: ${action.message}';
      color = const Color(0xFF3F51B5); // Indigo color
    } else {
      icon = Icons.help;
      title = S.of(context).unknown;
      subtitle = '';
      color = theme.iconTheme.color!;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium,
        ),
        if (subtitle != null) ...[
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium,
          ),
        ],
        SizedBox(height: 16.h),
        child,
      ],
    );
  }

  void _editAutomation() {
    context.push(
      EditAutomationScreen(automation: _currentAutomation),
    );
  }

  void _toggleAutomationStatus() {
    if (_currentAutomation.id != null && !_isChangingStatus) {
      context
          .read<AutomationCubit>()
          .changeAutomationStatus(_currentAutomation.id!);
    }
  }

  void _showDeleteDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteAutomation),
        content: Text(S.of(context).deleteAutomationConfirmation),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _deleteAutomation();
            },
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAutomation() {
    if (_currentAutomation.id != null) {
      context.read<AutomationCubit>().deleteAutomation(_currentAutomation.id!);
    }
  }
}
