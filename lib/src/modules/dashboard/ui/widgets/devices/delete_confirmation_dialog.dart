import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

class DeleteDeviceDialog extends StatelessWidget {
  final String deviceId;

  const DeleteDeviceDialog({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: DevicesCubit.get(),
      child: BlocConsumer<DevicesCubit, DevicesState>(
        listener: (context, state) {
          if (state is DeleteDeviceSuccess) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).deviceDeletedSuccessfully,
                  style: theme.snackBarTheme.contentTextStyle,
                ),
              ),
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
            backgroundColor: theme.dialogTheme.backgroundColor,
            shape: theme.dialogTheme.shape,
            title: Text(
              S.of(context).deleteDevice,
              style: theme.dialogTheme.titleTextStyle?.copyWith(
                fontSize: 18.sp,
              ),
            ),
            content: Text(
              S.of(context).confirmDeleteDevice,
              style: theme.dialogTheme.contentTextStyle?.copyWith(
                fontSize: 14.sp,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                style: theme.textButtonTheme.style?.copyWith(
                  foregroundColor: MaterialStateProperty.all(
                    theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                child: Text(
                  S.of(context).cancel,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              ElevatedButton(
                onPressed: state is DeleteDeviceLoading
                    ? null
                    : () {
                        DevicesCubit.get().deleteDevice(deviceId);
                      },
                style: theme.elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return theme.colorScheme.error.withOpacity(0.5);
                      }
                      return theme.colorScheme.error;
                    },
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    theme.colorScheme.onError,
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size(80.w, 36.h),
                  ),
                ),
                child: state is DeleteDeviceLoading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onError,
                          ),
                        ),
                      )
                    : Text(
                        S.of(context).yesDelete,
                        style: TextStyle(fontSize: 14.sp),
                      ),
              ),
            ],
            actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            titlePadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          );
        },
      ),
    );
  }
}
