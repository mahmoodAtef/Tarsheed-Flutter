import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/device.dart';
import '../../../../core/utils/color_manager.dart';

class EditDeviceDialog extends StatefulWidget {
  final Device device;
  const EditDeviceDialog({Key? key, required this.device}) : super(key: key);

  @override
  State<EditDeviceDialog> createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<EditDeviceDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController pinNumberController;
  bool isModified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.device.name);
    descriptionController = TextEditingController(text: widget.device.description);
    pinNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listenWhen: (previous, current) =>
      current is EditDeviceSuccess || current is EditDeviceError,
      listener: (context, state) {
        if (state is EditDeviceSuccess) {
          Navigator.of(context).pop();
        } else if (state is EditDeviceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to edit device')),
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Device'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Device Name', nameController),
              const SizedBox(height: 10),
              _buildTextField('Description', descriptionController),
              const SizedBox(height: 10),
              _buildTextField('Pin Number', pinNumberController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: isModified && !isLoading ? _onSavePressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isModified ? ColorManager.primary : Colors.grey,
            ),
            child: isLoading
                ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      onChanged: (_) => setState(() => isModified = true),
    );
  }

  void _onSavePressed() {
    setState(() => isLoading = true);
    context.read<DashboardBloc>().add(
      EditDeviceEvent(
        id: widget.device.id,
        name: nameController.text,
        description: descriptionController.text,
        pinNumber: pinNumberController.text,
      ),
    );
  }
}
