import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';

class DeleteSensorDialog extends StatelessWidget {
  final String sensorId;

  const DeleteSensorDialog({Key? key, required this.sensorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>(),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DeleteSensorSuccessState) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).sensorDeletedSuccessfully)),
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
            title: Text(S.of(context).deleteSensor),
            content: Text(S.of(context).confirmDeleteSensor),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!isLoading) {
                    sl<DashboardBloc>().add(DeleteSensorEvent(sensorId));
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: isLoading
                    ? Center(child: CustomLoadingWidget())
                    : Text(S.of(context).yesDelete),
              ),
            ],
          );
        },
      ),
    );
  }
}
