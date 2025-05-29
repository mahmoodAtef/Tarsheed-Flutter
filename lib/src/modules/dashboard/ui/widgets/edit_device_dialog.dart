import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

import '../../../../core/utils/color_manager.dart';
import '../../data/models/device.dart';

class EditDeviceDialog extends StatefulWidget {
  final Device device;

  const EditDeviceDialog({super.key, required this.device});

  @override
  State<EditDeviceDialog> createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<EditDeviceDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController pinNumberController;
  bool isModified = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.device.name);
    descriptionController =
        TextEditingController(text: widget.device.description);
    pinNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DevicesCubit>(
      create: (context) => sl<DevicesCubit>(),
      child: BlocListener<DevicesCubit, DevicesState>(
        listenWhen: (previous, current) =>
            current is EditDeviceSuccess || current is EditDeviceError,
        listener: (context, state) {
          if (state is EditDeviceSuccess) {
            Navigator.of(context).pop();
          } else if (state is EditDeviceError) {
            ExceptionManager.showMessage(state.exception);
          }
        },
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(S.of(context).editDevice),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(S.of(context).name, nameController),
                const SizedBox(height: 10),
                _buildTextField(
                    S.of(context).description, descriptionController),
                const SizedBox(height: 10),
                _buildTextField(S.of(context).pinNumber, pinNumberController,
                    keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(S.of(context).cancel),
            ),
            BlocBuilder<DevicesCubit, DevicesState>(
              bloc: sl<DevicesCubit>(),
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: isModified ? _onSavePressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isModified ? ColorManager.primary : Colors.grey,
                  ),
                  child: state is EditDeviceLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(S.of(context).save),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      onChanged: (_) => setState(() => isModified = true),
    );
  }

  void _onSavePressed() {
    sl<DevicesCubit>().editDevice(
      id: widget.device.id,
      name: nameController.text,
      description: descriptionController.text,
      pinNumber: pinNumberController.text,
    );
  }
}
