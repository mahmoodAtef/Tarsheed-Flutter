import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/reports_cubit/reports_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/devices/connected_devices_list.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/home_header.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/reports/energy_consumption_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: BlocProvider<DevicesCubit>(
        create: (context) => DevicesCubit.get(),
        child: ConnectionWidget(
          onRetry: _initializeData,
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: _buildScrollableContent(context, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Builder(
        builder: (context) {
          _initializeData();
          return _buildMainContent(theme);
        },
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme) {
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSection(),
        _buildEnergyConsumptionSection(theme),
        _buildSpacing(),
        _buildDevicesSection(theme),
        _buildBottomSpacing(),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return const HeaderSection();
  }

  Widget _buildEnergyConsumptionSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: EnergyConsumptionSection(),
    );
  }

  Widget _buildSpacing() {
    return SizedBox(height: 16.h);
  }

  Widget _buildDevicesSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: ConnectedDevicesList(),
    );
  }

  Widget _buildBottomSpacing() {
    return SizedBox(height: 20.h);
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
      _loadReportsData();
      _loadDevicesData();
    });
  }

  void _loadDashboardData() {
    final bloc = DashboardBloc.get();
    bloc.add(GetRoomsEvent());
    bloc.add(GetDevicesCategoriesEvent());
  }

  void _loadReportsData() {
    final reportsCubit = ReportsCubit.get();
    final now = DateTime.now();
    final period = "${now.month}-${now.year}";
    reportsCubit.getUsageReport(period: period);
  }

  void _loadDevicesData() {
    final devicesCubit = DevicesCubit.get();
    devicesCubit.getDevices();
  }
}
