import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/core/widgets/large_button.dart';
import 'package:tarsheed/src/core/widgets/text_field.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor_category.dart';

import '../../bloc/dashboard_bloc.dart';

class AddSensorFormPage extends StatefulWidget {
  const AddSensorFormPage({super.key});

  @override
  State<AddSensorFormPage> createState() => _AddSensorFormPageState();
}

class _AddSensorFormPageState extends State<AddSensorFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pinNumberController = TextEditingController();
  String? selectedPin;
  String? selectedRoomId;
  List<String> rooms = [];
  SensorCategory? selectedSensorType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationManager.currentLocaleIndex == 0;

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).addSensor)),
      body: BlocProvider(
        create: (context) => DashboardBloc.get()..add(GetRoomsEvent()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return S.of(context).nameRequired;
                      }
                      return null;
                    },
                    controller: nameController,
                    hintText: 'Sensor Name',
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return S.of(context).pinNumberRequired;
                      }
                      return null;
                    },
                    controller: pinNumberController,
                    hintText: 'PinNumber',
                  ),
                  const SizedBox(height: 12),

                  ///Rooms Dropdown
                  BlocBuilder<DashboardBloc, DashboardState>(
                    buildWhen: (current, previous) =>
                        current is RoomState ||
                        current is AddSensorLoadingState,
                    builder: (context, state) {
                      final rooms = DashboardBloc.get().rooms;
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

                  ///Sensor Dropdown
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SensorCategory>(
                    value: selectedSensorType,
                    decoration: InputDecoration(
                      labelText:
                          isArabic ? 'اختر جهاز الاستشعار' : 'Select Sensor',
                    ),
                    items: SensorCategory.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Image.asset(
                              type.imagePath,
                              color: ColorManager.black,
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            Text(type.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedSensorType = value),
                  ),

                  SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BlocConsumer<DashboardBloc, DashboardState>(
                      listener: (context, state) {
                        if (state is AddSensorLoadingState) {
                          showToast(S.of(context).sensorAdded);
                          context.pop();
                        }
                      },
                      buildWhen: (current, previous) =>
                          current is SensorState ||
                          current is AddSensorLoadingState,
                      builder: (context, state) => DefaultButton(
                        title: S.of(context).save,
                        isLoading: state is AddSensorLoadingState,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            DashboardBloc.get().add(AddSensorEvent(Sensor(
                              name: nameController.text,
                              categoryId: selectedSensorType!.id,
                              pinNumber: pinNumberController.text,
                              roomId: selectedRoomId!,
                              category: selectedSensorType!,
                              description: descriptionController.text,
                            )));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
