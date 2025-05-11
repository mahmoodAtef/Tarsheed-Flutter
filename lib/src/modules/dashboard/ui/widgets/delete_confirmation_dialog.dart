import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

class DeleteDeviceDialog extends StatelessWidget {
  final String deviceId;

  const DeleteDeviceDialog({Key? key, required this.deviceId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Device'),
      content: const Text('Are you sure you want to delete this device?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            sl<DevicesCubit>().deleteDevice(deviceId);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text('Yes, Delete'),
        ),
      ],
    );
  }
}
