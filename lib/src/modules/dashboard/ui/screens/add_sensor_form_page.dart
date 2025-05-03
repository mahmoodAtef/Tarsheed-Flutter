import 'package:flutter/material.dart';

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
  String? selectedCategoryId;

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
            DropdownButtonFormField<String>(
              value: selectedRoomId,
              hint: const Text('Select Room'),
              items: const [],
              onChanged: (value) => setState(() => selectedRoomId = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategoryId,
              hint: const Text('Select Category'),
              items: const [],
              onChanged: (value) => setState(() => selectedCategoryId = value),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
