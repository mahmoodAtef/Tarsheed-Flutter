import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';

import '../../bloc/dashboard_bloc.dart';

enum SensorCategory {
  temperature,
  current,
  motion,
  vibration,
}

extension SensorData on SensorCategory {
  String get name {
    bool isArabic = LocalizationManager.currentLocaleIndex == 0;
    switch (this) {
      case SensorCategory.temperature:
        return isArabic ? "مستشعر حرارة" : "Temperature Sensor";
      case SensorCategory.current:
        return isArabic ? "مستشعر التيار" : "Current Sensor";
      case SensorCategory.motion:
        return isArabic ? "مستشعر الحركة" : "Motion Sensor";
      case SensorCategory.vibration:
        return isArabic ? "مستشعر الاهتزاز" : "Vibration Sensor";
    }
  }

  String get id {
    switch (this) {
      case SensorCategory.temperature:
        return "6817b4b7f927a0b34e0756d7";
      case SensorCategory.current:
        return "6817b5bda500e527dbafb536";
      case SensorCategory.motion:
        return "6817b5bda500e527dbafb536";
      case SensorCategory.vibration:
        return "6817b5e3dc386af5382343f3";
    }
  }
}

class AddSensorFormPage extends StatefulWidget {
  const AddSensorFormPage({super.key});

  @override
  State<AddSensorFormPage> createState() => _AddSensorFormPageState();
}

class _AddSensorFormPageState extends State<AddSensorFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedPin;
  String? selectedRoomId;
  SensorCategory? selectedSensorType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Sensor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Sensor Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedPin,
              hint: const Text('Select Pin Number'),
              items: const [],
              onChanged: (value) => setState(() => selectedPin = value),
            ),
            const SizedBox(height: 12),

            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                final rooms = context.read<DashboardBloc>().rooms;
                return DropdownButtonFormField<String>(
                  value: selectedRoomId,
                  hint: const Text('Select Room'),
                  items: rooms.map((room) {
                    return DropdownMenuItem<String>(
                      value: room.id,
                      child: Text(room.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedRoomId = value),
                );
              },
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<SensorCategory>(
              value: selectedSensorType,
              hint: Text(LocalizationManager.currentLocaleIndex == 0 ? 'اختر النوع' : 'Select Type'),
              items: SensorCategory.values.map((type) {
                return DropdownMenuItem<SensorCategory>(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedSensorType = value),
            ),
            const Spacer(flex: 1,),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final sensorTypeId = selectedSensorType?.id;

                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
