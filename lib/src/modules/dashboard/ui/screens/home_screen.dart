import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/reports_cubit/reports_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/devices/connected_devices_list.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/energy_consumption_section.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<DevicesCubit>(
        create: (context) => DevicesCubit.get(),
        child: ConnectionWidget(
          onRetry: _initializeData,
          child: SingleChildScrollView(
            child: Builder(builder: (context) {
              _initializeData();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: EnergyConsumptionSection(),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: ConnectedDevicesList(),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = DashboardBloc.get();
      final reportsCubit = ReportsCubit.get();
      final DevicesCubit devicesCubit = DevicesCubit.get();
      final now = DateTime.now();
      reportsCubit.getUsageReport(period: "${now.month}-${now.year}");
      bloc.add(GetRoomsEvent());
      bloc.add(GetDevicesCategoriesEvent());
      devicesCubit.getDevices();
    });
  }
}
