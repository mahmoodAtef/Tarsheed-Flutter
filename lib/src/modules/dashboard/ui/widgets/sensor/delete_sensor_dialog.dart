import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';

class DeleteSensorDialog extends StatelessWidget {
  final String sensorId;

  const DeleteSensorDialog({Key? key, required this.sensorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocProvider.value(
      value: DashboardBloc.get(),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DeleteSensorSuccessState) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).sensorDeletedSuccessfully),
                backgroundColor: theme.snackBarTheme.backgroundColor,
                behavior: theme.snackBarTheme.behavior,
                shape: theme.snackBarTheme.shape,
              ),
            );
          } else if (state is DeleteSensorErrorState) {
            ExceptionManager.showMessage(state.exception);
          }
        },
        buildWhen: (previous, current) =>
            current is DeleteSensorLoadingState ||
            current is DashboardInitial ||
            current is DeleteSensorErrorState ||
            current is DeleteSensorSuccessState,
        builder: (context, state) {
          bool isLoading = state is DeleteSensorLoadingState;

          return AlertDialog(
            backgroundColor: theme.dialogTheme.backgroundColor,
            elevation: theme.dialogTheme.elevation,
            shape: theme.dialogTheme.shape,
            title: Text(
              S.of(context).deleteSensor,
              style: theme.dialogTheme.titleTextStyle,
            ),
            content: Text(
              S.of(context).confirmDeleteSensor,
              style: theme.dialogTheme.contentTextStyle,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                style: theme.textButtonTheme.style,
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!isLoading) {
                    DashboardBloc.get().add(DeleteSensorEvent(sensorId));
                  }
                },
                style: theme.elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all(colorScheme.error),
                  foregroundColor:
                      MaterialStateProperty.all(colorScheme.onError),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: CustomLoadingWidget(),
                      )
                    : Text(S.of(context).yesDelete),
              ),
            ],
          );
        },
      ),
    );
  }
}
