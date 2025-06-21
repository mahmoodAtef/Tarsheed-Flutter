// trigger_components.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/modules/automation/ui/ui_models/ui_models.dart';
import 'package:tarsheed/src/modules/automation/ui/widgets/components.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';

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
