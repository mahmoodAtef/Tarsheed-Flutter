import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor_category.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/sensor/delete_sensor_dialog.dart';

class SensorCard extends StatelessWidget {
  final Sensor sensor;
  final bool? editable;
  final bool? deletable;

  const SensorCard({
    required this.sensor,
    this.editable = true,
    this.deletable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      color: theme.cardTheme.color,
      shadowColor: theme.cardTheme.shadowColor,
      elevation: theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      margin: theme.cardTheme.margin,
      child: InkWell(
        onLongPress: () {
          if (editable == true) {
            showDialog(
                context: context,
                builder: (context) {
                  return DeleteSensorDialog(sensorId: sensor.id!);
                });
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.all(8.w),
                child: ImageIcon(
                  color: colorScheme.onPrimary,
                  AssetImage(sensor.category.imagePath),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sensor.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      sensor.description,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  sensor.category.name,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
