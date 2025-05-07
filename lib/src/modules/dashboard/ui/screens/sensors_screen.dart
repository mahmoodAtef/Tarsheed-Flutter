import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';

import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/bottom_navigator_bar.dart';
import '../../../../core/widgets/rectangle_background.dart';
import 'add_sensor_form_page.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: BackGroundRectangle()),
            Column(
              children: [
                const CustomAppBar(text: 'Sensors'),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  child: BlocBuilder(
                      buildWhen: (previous, current) => current is SensorState,
                      bloc: DashboardBloc.get()..add((GetSensorsEvent())),
                      builder: (context, state) {
                        if (state is GetSensorsLoadingState) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 100.h,
                              horizontal: 10.w,
                            ),
                            child: SizedBox(
                              height: 120.h,
                              child: CustomLoadingWidget(),
                            ),
                          );
                        } else if (state is GetSensorsErrorState) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 100.h,
                              horizontal: 10.w,
                            ),
                            child: SizedBox(
                              height: 120,
                              child: CustomErrorWidget(
                                  message: ExceptionManager.getMessage(
                                      state.exception)),
                            ),
                          );
                        } else if ((state is GetSensorsSuccessState &&
                                state.sensors.isEmpty) ||
                            DashboardBloc.get().sensors.isEmpty) {
                          return NoDataWidget();
                        } else {
                          return Container(); // Todo: replace it with Sensors Widget
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),

      // Add Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primary,
        onPressed: () {
          context.push(AddSensorFormPage());
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigator(),
    );
  }
}
