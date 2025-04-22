import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import '../../../../core/error/exception_manager.dart';
import '../widgets/device_model_adding.dart';

class DeviceFormPage extends StatefulWidget {
  final DeviceModel? initialDevice;

  const DeviceFormPage({super.key, this.initialDevice});

  @override
  State<DeviceFormPage> createState() => _DeviceFormPageState();
}

class _DeviceFormPageState extends State<DeviceFormPage> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedCategoryId;
  String? selectedCategoryName;
  String? selectedCategoryIcon;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetDevicesCategoriesEvent());

    if (widget.initialDevice != null) {
      _nameController.text = widget.initialDevice!.name;

    }
  }

  void _saveDevice() {
    if (_nameController.text.isEmpty || selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    final newDevice = DeviceModel(
      name: _nameController.text,
      type: selectedCategoryName ?? '',
      icon: selectedCategoryIcon ?? '',
      isActive: widget.initialDevice?.isActive ?? false,
    );

    Navigator.pop(context, newDevice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.initialDevice != null ? 'Edit Device' : 'Add Device')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Device Name'),
            ),
            const SizedBox(height: 20),

            /// Dropdown for categories
            BlocConsumer<DashboardBloc, DashboardState>(
              listener: (context, state) {
                if (state is GetDeviceCategoriesError) {
                  ExceptionManager.showMessage(state.exception);
                }
              },
              builder: (context, state) {
                if (state is GetDeviceCategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetDeviceCategoriesSuccess) {
                  final categories = state.deviceCategories;

                  return DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    hint: const Text("Select Category"),
                    items: categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.id,
                        child: Row(
                          children: [
                            Image.network(
                              cat.icon ?? '',
                              width: 24,
                              height: 24,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                            const SizedBox(width: 10),
                            Text(cat.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      final selected = categories.firstWhere((e) => e.id == val);
                      setState(() {
                        selectedCategoryId = val;
                        selectedCategoryName = selected.name;
                        selectedCategoryIcon = selected.icon;
                      });
                    },
                  );
                } else {
                  return const Text('No categories found.');
                }
              },
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveDevice,
              child: Text(widget.initialDevice != null ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
