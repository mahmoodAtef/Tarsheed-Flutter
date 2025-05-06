import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
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
  SensorCategory? selectedSensorType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Sensor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  final rooms = context.read<DashboardBloc>().rooms;
                  return DropdownButtonFormField<String>(
                    validator: (v) {
                      if (v == null) {
                        return S.of(context).roomRequired;
                      }
                      return null;
                    },
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
              DropdownButtonFormField<SensorCategory>(
                validator: (v) {
                  if (v == null) {
                    return S.of(context).typeRequired;
                  }
                  return null;
                },
                value: selectedSensorType,
                hint: Text(LocalizationManager.currentLocaleIndex == 0
                    ? 'اختر النوع'
                    : 'Select Type'),
                items: SensorCategory.values.map((type) {
                  return DropdownMenuItem<SensorCategory>(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => selectedSensorType = value),
              ),
              const Spacer(
                flex: 1,
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
                      current is SensorState || current is AddDeviceLoading,
                  builder: (context, state) => DefaultButton(
                    title: S.of(context).save,
                    isLoading: state is AddDeviceLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        DashboardBloc.get().add(AddSensorEvent(Sensor(
                            name: nameController.text,
                            categoryId: selectedSensorType!.id,
                            pinNumber: pinNumberController.text,
                            roomId: selectedRoomId!,
                            description: descriptionController.text,
                            id: "")));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
