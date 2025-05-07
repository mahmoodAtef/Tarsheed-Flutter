import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/large_button.dart';
import '../../../../core/utils/localization_manager.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/device_creation_form.dart';
import '../../data/models/sensor_category.dart';

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
  int? selectedPriority;

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationManager.currentLocaleIndex == 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Device')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
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
                        onChanged: (value) =>
                            setState(() => selectedRoomId = value),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  /// Category Dropdown from Bloc
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: LocalizationManager.currentLocaleIndex == 0
                              ? 'اختر الفئة'
                              : 'Select Category',
                        ),
                        items: DashboardBloc.get().categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => selectedCategoryId = val),
                      );
                    },
                  ),
                  /// sensors Dropdown
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SensorCategory>(
                    value: selectedSensorType,
                    decoration: InputDecoration(
                      labelText: isArabic ? 'اختر جهاز الاستشعار' : 'Select Sensor',
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
                  const SizedBox(height: 12),
                  /// priority Dropdown
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
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0.w),
            child: SizedBox(
              width: double.maxFinite,
              child: BlocConsumer<DashboardBloc, DashboardState>(
                listener: (context, state) {
                  if (state is AddDeviceSuccess) {
                    Fluttertoast.showToast(msg: "device added successfully");
                    context.pop();
                  }
                },
                buildWhen: (current, previous) =>
                    current is DeviceState ||
                    current is AddDeviceLoading ||
                    current is AddDeviceSuccess ||
                    current is AddDeviceError,
                builder: (context, state) {
                  return DefaultButton(
                      title: S.of(context).save,
                      isLoading: state is AddDeviceLoading,
                      onPressed: () {
                        if (_validateInputs()) {
                          final form = DeviceCreationForm(
                            name: nameController.text,
                            description: descriptionController.text,
                            pinNumber: pinNumberController.text,
                            roomId: selectedRoomId!,
                            categoryId: selectedCategoryId!,
                            priority:
                                int.tryParse(priorityController.text) ?? 1,
                          );

                          context
                              .read<DashboardBloc>()
                              .add(AddDeviceEvent(form));
                        }
                      });
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        pinNumberController.text.isEmpty ||
        selectedRoomId == null ||
        selectedCategoryId == null ||
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
