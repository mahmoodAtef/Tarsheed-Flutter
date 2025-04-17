import 'package:flutter/material.dart';
import '../widgets/device_model_adding.dart';

class DeviceFormPage extends StatefulWidget {
  final DeviceModel? initialDevice;

  const DeviceFormPage({super.key, this.initialDevice});

  @override
  State<DeviceFormPage> createState() => _DeviceFormPageState();
}

class _DeviceFormPageState extends State<DeviceFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  IconData? selectedIcon;

  final List<IconData> icons = [
    Icons.lightbulb_outline,
    Icons.tv,
    Icons.wifi,
    Icons.videocam,
    Icons.ac_unit,
    Icons.fireplace,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialDevice != null) {
      _nameController.text = widget.initialDevice!.name;
      _typeController.text = widget.initialDevice!.type;
      selectedIcon = widget.initialDevice!.icon;
    }
  }

  void _saveDevice() {
    if (_nameController.text.isEmpty ||
        _typeController.text.isEmpty ||
        selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    final newDevice = DeviceModel(
      icon: selectedIcon!,
      name: _nameController.text,
      type: _typeController.text,
      isActive: widget.initialDevice?.isActive ?? false,
    );

    Navigator.pop(context, newDevice);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialDevice != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Device' : 'Add Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select Icon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: icons.map((iconData) {
                final isSelected = iconData == selectedIcon;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIcon = iconData;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      iconData,
                      size: 30,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Device Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Device Type'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveDevice,
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
