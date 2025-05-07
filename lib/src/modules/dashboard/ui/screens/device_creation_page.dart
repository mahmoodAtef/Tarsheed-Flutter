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

  List<String> rooms = [];

  @override
  Widget build(BuildContext context) {
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

                  const SizedBox(height: 12),

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
