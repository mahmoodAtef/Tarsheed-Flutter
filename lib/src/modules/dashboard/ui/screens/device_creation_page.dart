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

  String? selectedRoomId;
  String? selectedCategoryId;
  SensorCategory? selectedSensorType;
  int? selectedPriority;

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationManager.currentLocaleIndex == 0;

    return Scaffold(
      appBar: AppBar(title: Text(isArabic ? 'إضافة جهاز' : 'Add Device')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: isArabic ? 'اسم الجهاز' : 'Device Name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: isArabic ? 'الوصف' : 'Description',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinNumberController,
              decoration: InputDecoration(
                labelText: isArabic ? 'رقم البن' : 'Pin Number',
              ),
            ),
            const SizedBox(height: 12),

            /// Priority Dropdown
            DropdownButtonFormField<int>(
              value: selectedPriority,
              decoration: InputDecoration(
                labelText: isArabic ? 'أولوية الجهاز' : 'Device Priority',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        isArabic
                            ? 'أولوية ١ - شديدة الأهمية'
                            : 'Priority 1 - Critical',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        isArabic
                            ? 'أولوية ٢ - مهمة'
                            : 'Priority 2 - Important',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        isArabic
                            ? 'أولوية ٣ - متوسطة'
                            : 'Priority 3 - Moderate',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: Row(
                    children: [
                      const Icon(Icons.low_priority, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        isArabic
                            ? 'أولوية ٤ - غير مهمة'
                            : 'Priority 4 - Low',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPriority = value;
                });
              },
            ),
            const SizedBox(height: 20),

            /// Room Dropdown
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                final rooms = context.read<DashboardBloc>().rooms;
                return DropdownButtonFormField<String>(
                  value: selectedRoomId,
                  hint: Text(isArabic ? 'اختر الغرفة' : 'Select Room'),
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

            /// Category Dropdown
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is GetDeviceCategoriesSuccess) {
                  final categories = state.deviceCategories;
                  return DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: isArabic ? 'اختر الفئة' : 'Select Category',
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => selectedCategoryId = val),
                  );
                }
                if (state is GetDeviceCategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: isArabic ? 'اختر الفئة' : 'Select Category',
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
                labelText: isArabic ? 'اختر النوع' : 'Select Type',
              ),
              items: SensorCategory.values.map((type) {
                return DropdownMenuItem<SensorCategory>(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => selectedSensorType = value),
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
                    priority: selectedPriority!,
                  );

                  context.read<DashboardBloc>().add(AddDeviceEvent(form));
                }
              },
              child: Text(isArabic ? 'حفظ الجهاز' : 'Save Device'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    bool isArabic = LocalizationManager.currentLocaleIndex == 0;

    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        pinNumberController.text.isEmpty ||
        selectedRoomId == null ||
        selectedCategoryId == null ||
        selectedSensorType == null ||
        selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'يرجى ملء جميع الحقول' : 'Please fill all fields',
          ),
        ),
      );
      return false;
    }
    return true;
  }
}
