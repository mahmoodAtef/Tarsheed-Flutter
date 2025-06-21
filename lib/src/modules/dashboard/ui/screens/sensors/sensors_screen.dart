import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/sensor/sensor_card.dart';

import '../../../../../core/widgets/appbar.dart';
import '../../../../../core/widgets/rectangle_background.dart';
import '../../../data/models/sensor_category.dart';
import 'add_sensor_form_page.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: DashboardBloc.get()..add(GetSensorsEvent()),
      child: RefreshIndicator(
        onRefresh: () async {
          DashboardBloc.get().add(GetSensorsEvent(isRefresh: true));
        },
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBody: true,
          body: SafeArea(
            child: Stack(
              children: [
                const Positioned.fill(child: BackGroundRectangle()),
                ConnectionWidget(
                  onRetry: () {
                    DashboardBloc.get().add(GetSensorsEvent());
                  },
                  child: Column(
                    children: [
                      CustomAppBar(text: S.of(context).sensors),
                      SizedBox(height: 10.h),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: _buildSensorsContent(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(context),
        ),
      ),
    );
  }

  Widget _buildSensorsContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: BlocBuilder(
        buildWhen: (previous, current) => current is SensorState,
        bloc: DashboardBloc.get()..add(GetSensorsEvent()),
        builder: (context, state) {
          if (state is GetSensorsLoadingState) {
            return _buildLoadingState(context);
          } else if (state is GetSensorsErrorState) {
            return _buildErrorState(context, state);
          } else if (_shouldShowNoData(state)) {
            return Center(
              child: NoDataWidget(),
            );
          } else {
            return _buildSensorsList(context);
          }
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 100.h,
        horizontal: 10.w,
      ),
      child: SizedBox(
        height: 120.h,
        child: const CustomLoadingWidget(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, GetSensorsErrorState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 100.h,
        horizontal: 10.w,
      ),
      child: SizedBox(
        height: 120.h,
        child: CustomErrorWidget(
          exception: state.exception,
        ),
      ),
    );
  }

  Widget _buildSensorsList(BuildContext context) {
    final sensors = DashboardBloc.get().sensors;

    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sensors.length,
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final sensor = sensors[index];
          final category = SensorCategory.values.firstWhere(
            (e) => e.id == sensor.categoryId,
            orElse: () => SensorCategory.temperature,
          );
          return SensorCard(sensor: sensor);
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
      foregroundColor: theme.floatingActionButtonTheme.foregroundColor,
      elevation: theme.floatingActionButtonTheme.elevation,
      onPressed: () {
        context.push(AddSensorFormPage());
      },
      tooltip: S.of(context).addSensor,
      child: const Icon(Icons.add),
    );
  }

  bool _shouldShowNoData(dynamic state) {
    return (state is GetSensorsSuccessState && state.sensors.isEmpty) ||
        DashboardBloc.get().sensors.isEmpty;
  }
}
