import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

class DeleteDeviceDialog extends StatelessWidget {
  final String deviceId;

  const DeleteDeviceDialog({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: DevicesCubit.get(),
      child: BlocConsumer<DevicesCubit, DevicesState>(
        listener: (context, state) {
          if (state is DeleteDeviceSuccess) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).deviceDeletedSuccessfully)),
            );
          } else if (state is DeleteDeviceError) {
            ExceptionManager.showMessage(state.exception);
          }
        },
        bloc: DevicesCubit.get(),
        buildWhen: (current, previous) =>
            current is DeleteDeviceLoading ||
            current is DeleteDeviceSuccess ||
            current is DeleteDeviceError,
        builder: (context, state) {
          return AlertDialog(
            title: Text(S.of(context).deleteDevice),
            content: Text(S.of(context).confirmDeleteDevice),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  DevicesCubit.get().deleteDevice(deviceId);
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: state is DeleteDeviceLoading
                    ? SizedBox(
                        child: Center(child: CircularProgressIndicator()))
                    : Text(S.of(context).yesDelete),
              ),
            ],
          );
        },
      ),
    );
  }
}
