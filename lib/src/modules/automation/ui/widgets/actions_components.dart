// action_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/modules/automation/ui/ui_models/ui_models.dart';
import 'package:tarsheed/src/modules/automation/ui/widgets/components.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

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
