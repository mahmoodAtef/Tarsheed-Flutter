import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String? selectedSensorId;

  List<String> rooms = [];
  List<String> categories = [];
  List<String> sensors = [];

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
            DropdownButtonFormField<String>(
              value: selectedRoomId,
              decoration: const InputDecoration(labelText: 'Select Room'),
              items: rooms.map((roomId) {
                return DropdownMenuItem(
                  value: roomId,
                  child: Text(roomId),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedRoomId = val),
            ),
            const SizedBox(height: 12),

            /// Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategoryId,
              decoration: const InputDecoration(labelText: 'Select Category'),
              items: categories.map((categoryId) {
                return DropdownMenuItem(
                  value: categoryId,
                  child: Text(categoryId),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedCategoryId = val),
            ),
            const SizedBox(height: 12),

            /// Sensor Dropdown
            DropdownButtonFormField<String>(
              value: selectedSensorId,
              decoration: const InputDecoration(labelText: 'Select Sensor'),
              items: sensors.map((sensorId) {
                return DropdownMenuItem(
                  value: sensorId,
                  child: Text(sensorId),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedSensorId = val),
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
                    sensorId: selectedSensorId!,
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
        selectedSensorId == null ||
        priorityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return false;
    }
    return true;
  }
}
