import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/appbar.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/all_automations_screen.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/devices/devices.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/payment_webview.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/rooms/rooms_screen.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/sensors/sensors_screen.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/dashboard_item.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildAppBar(context),
          _buildMainContent(context, theme),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      text: S.of(context).myHome,
      withBackButton: false,
    );
  }

  Widget _buildMainContent(BuildContext context, ThemeData theme) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            children: [
              _buildTopSpacing(),
              _buildMenuItems(context, theme),
              _buildBottomSpacing(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSpacing() {
    return SizedBox(height: 20.h);
  }

  Widget _buildBottomSpacing() {
    return SizedBox(height: 20.h);
  }

  Widget _buildMenuItems(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        _buildDevicesItem(context, theme),
        _buildItemSpacing(),
        _buildSensorsItem(context, theme),
        _buildItemSpacing(),
        _buildAutomationsItem(context, theme),
        _buildItemSpacing(),
        _buildRoomsItem(context, theme),
        _buildItemSpacing(),
        _buildPaymentItem(context, theme),
      ],
    );
  }

  Widget _buildItemSpacing() {
    return SizedBox(height: 12.h);
  }

  Widget _buildDevicesItem(BuildContext context, ThemeData theme) {
    return DashboardItem(
      icon: Icons.devices,
      title: S.of(context).devices,
      subtitle: S.of(context).manageYourDevices,
      onTap: () => _navigateToDevices(context),
    );
  }

  Widget _buildSensorsItem(BuildContext context, ThemeData theme) {
    return DashboardItem(
      icon: Icons.sensors,
      title: S.of(context).sensors,
      subtitle: S.of(context).manageYourSensors,
      onTap: () => _navigateToSensors(context),
    );
  }

  Widget _buildAutomationsItem(BuildContext context, ThemeData theme) {
    return DashboardItem(
      icon: Icons.auto_awesome,
      title: S.of(context).automations,
      subtitle: S.of(context).manageYourAutomations,
      onTap: () => _navigateToAutomations(context),
    );
  }

  Widget _buildRoomsItem(BuildContext context, ThemeData theme) {
    return DashboardItem(
      icon: Icons.door_back_door_outlined,
      title: S.of(context).rooms,
      subtitle: S.of(context).manageYourRooms,
      onTap: () => _navigateToRooms(context),
    );
  }

  Widget _buildPaymentItem(BuildContext context, ThemeData theme) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) => _handlePaymentStateListener(context, state),
      buildWhen: (previous, current) => _shouldRebuildPaymentItem(current),
      listenWhen: (previous, current) =>
          _shouldListenToPaymentState(previous, current),
      builder: (context, state) =>
          _buildPaymentItemContent(context, state, theme),
    );
  }

  Widget _buildPaymentItemContent(
      BuildContext context, DashboardState state, ThemeData theme) {
    if (state is GetPaymentUrlLoadingState) {
      return _buildPaymentLoadingWidget(theme);
    }

    return DashboardItem(
      icon: Icons.payments,
      title: S.of(context).payBills,
      subtitle: S.of(context).payBillsDescription,
      onTap: () => _requestPaymentUrl(),
    );
  }

  Widget _buildPaymentLoadingWidget(ThemeData theme) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.cardTheme.shadowColor?.withOpacity(0.1) ??
                Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CustomLoadingWidget(),
      ),
    );
  }

  // Navigation methods
  void _navigateToDevices(BuildContext context) {
    context.push(
      BlocProvider.value(
        value: DevicesCubit.get(),
        child: const DevicesScreen(),
      ),
    );
  }

  void _navigateToSensors(BuildContext context) {
    context.push(const SensorsScreen());
  }

  void _navigateToAutomations(BuildContext context) {
    context.push(const AllAutomationsScreen());
  }

  void _navigateToRooms(BuildContext context) {
    context.push(const RoomsScreen());
  }

  // Payment methods
  void _requestPaymentUrl() {
    DashboardBloc.get().add(GetPaymentUrlEvent());
  }

  void _handlePaymentStateListener(BuildContext context, DashboardState state) {
    if (state is GetPaymentUrlErrorState) {
      ExceptionManager.showMessage(state.exception);
    }

    if (state is GetPaymentUrlSuccessState) {
      context.push(PaymentWebView(url: state.paymentUrl));
    }
  }

  // Condition methods
  bool _shouldRebuildPaymentItem(DashboardState current) {
    return current is GetPaymentUrlLoadingState ||
        current is GetPaymentUrlSuccessState ||
        current is GetPaymentUrlErrorState;
  }

  bool _shouldListenToPaymentState(
      DashboardState previous, DashboardState current) {
    return current is GetPaymentUrlErrorState ||
        current is GetPaymentUrlSuccessState ||
        previous is GetPaymentUrlSuccessState ||
        previous is GetPaymentUrlErrorState;
  }
}
