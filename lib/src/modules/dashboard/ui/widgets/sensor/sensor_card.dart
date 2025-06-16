import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
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
    return Card(
      color: ColorManager.white,
      borderOnForeground: true,
      shadowColor: ColorManager.black,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: ImageIcon(
                  color: ColorManager.white,
                  AssetImage(sensor.category.imagePath),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sensor.name,
                      style: const TextStyle(
                        color: ColorManager.darkGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sensor.description,
                      style: const TextStyle(
                        color: ColorManager.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sensor.category.name,
                  style: const TextStyle(
                    color: ColorManager.primary,
                    fontSize: 14,
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
