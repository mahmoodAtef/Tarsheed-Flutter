import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/localization_manager.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/category.dart';
import '../../data/models/device_creation_form.dart';

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

class DeviceCreationPage extends StatefulWidget {
  @override
  _DeviceCreationPageState createState() => _DeviceCreationPageState();
}

class _DeviceCreationPageState extends State<DeviceCreationPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final pinNumberController = TextEditingController();
  final priorityController = TextEditingController();

  String? selectedRoomId;
  String? selectedCategoryId;
  SensorCategory? selectedSensorType;

  List<String> rooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Device')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Device Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinNumberController,
              decoration: const InputDecoration(labelText: 'Pin Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priorityController,
              decoration: const InputDecoration(labelText: 'Priority'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            /// Room Dropdown
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

            /// Category Dropdown from Bloc
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is GetDeviceCategoriesSuccess) {
                  final categories = state.deviceCategories;
                  return DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: LocalizationManager.currentLocaleIndex == 0
                          ? 'اختر الفئة'
                          : 'Select Category',
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedCategoryId = val),
                  );
                }
                if (state is GetDeviceCategoriesLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: LocalizationManager.currentLocaleIndex == 0
                        ? 'اختر الفئة'
                        : 'Select Category',
                  ),
                  items: [],
                  onChanged: null,
                );
              },
            ),

            const SizedBox(height: 12),

            /// Sensor Dropdown
            DropdownButtonFormField<SensorCategory>(
              value: selectedSensorType,
              decoration: InputDecoration(
                labelText: LocalizationManager.currentLocaleIndex == 0
                    ? 'اختر النوع'
                    : 'Select Type',
              ),
              items: SensorCategory.values.map((type) {
                return DropdownMenuItem<SensorCategory>(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedSensorType = value),
            ),
            const SizedBox(height: 20),

            /// Save Button
            ElevatedButton(
              onPressed: () {
                if (_validateInputs()) {
                  final form = DeviceCreationForm(
                    name: nameController.text,
                    description: descriptionController.text,
                    pinNumber: pinNumberController.text,
                    roomId: selectedRoomId!,
                    categoryId: selectedCategoryId!,
                    sensorId: selectedSensorType!.id,
                    priority: int.tryParse(priorityController.text) ?? 1,
                  );

                  context.read<DashboardBloc>().add(AddDeviceEvent(form));
                }
              },
              child: const Text('Save Device'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        pinNumberController.text.isEmpty ||
        selectedRoomId == null ||
        selectedCategoryId == null ||
        selectedSensorType == null ||
        priorityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocalizationManager.currentLocaleIndex == 0
              ? 'يرجى ملء جميع الحقول'
              : 'Please fill all fields'),
        ),
      );
      return false;
    }
    return true;
  }
}
