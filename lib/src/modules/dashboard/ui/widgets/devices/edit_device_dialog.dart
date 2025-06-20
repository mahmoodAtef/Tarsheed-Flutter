import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

import '../../../data/models/device.dart';

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
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    pinNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider<DevicesCubit>(
      create: (context) => DevicesCubit.get(),
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
          shape: theme.dialogTheme.shape,
          backgroundColor: theme.dialogTheme.backgroundColor,
          title: Text(
            S.of(context).editDevice,
            style: theme.dialogTheme.titleTextStyle,
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 280.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    S.of(context).deviceName,
                    nameController,
                    theme,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    S.of(context).description,
                    descriptionController,
                    theme,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    S.of(context).pinNumber,
                    pinNumberController,
                    theme,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              style: theme.textButtonTheme.style,
              child: Text(
                S.of(context).cancel,
                style: theme.textButtonTheme.style?.textStyle?.resolve({}),
              ),
            ),
            SizedBox(width: 8.w),
            BlocBuilder<DevicesCubit, DevicesState>(
              bloc: DevicesCubit.get(),
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: isModified ? _onSavePressed : null,
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return theme.colorScheme.onSurface.withOpacity(0.12);
                        }
                        return theme.colorScheme.primary;
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return theme.colorScheme.onSurface.withOpacity(0.38);
                        }
                        return theme.colorScheme.onPrimary;
                      },
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    ),
                  ),
                  child: state is EditDeviceLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                            strokeWidth: 2.w,
                          ),
                        )
                      : Text(
                          S.of(context).save,
                          style: theme.elevatedButtonTheme.style?.textStyle
                              ?.resolve({}),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    ThemeData theme, {
    TextInputType? keyboardType,
  }) {
    return Theme(
      data: ThemeData(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        labelStyle: theme.inputDecorationTheme.labelStyle,
        hintStyle: theme.inputDecorationTheme.hintStyle,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
      )),
      child: TextField(
        decoration: InputDecoration(labelText: label),
        controller: controller,
        keyboardType: keyboardType,
        style: theme.textTheme.bodyMedium,
        onChanged: (_) => setState(() => isModified = true),
      ),
    );
  }

  void _onSavePressed() {
    DevicesCubit.get().editDevice(
      id: widget.device.id,
      name: nameController.text,
      description: descriptionController.text,
      pinNumber:
          int.tryParse(pinNumberController.text) ?? widget.device.pinNumber,
    );
  }
}
