import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/appbar.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/card_item.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/all_automations_screen.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/devices/devices.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/payment_webview.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/rooms_screen.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/sensors_screen.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(
          text: S.of(context).myHome,
          withBackButton: false,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                BuildItem(
                  icon: Icons.devices,
                  title: S.of(context).devices,
                  subtitle: S.of(context).manageYourDevices,
                  onTap: () {
                    context.push(BlocProvider.value(
                      value: DevicesCubit.get(),
                      child: DevicesScreen(),
                    ));
                  },
                ),
                BuildItem(
                  icon: Icons.sensors,
                  title: S.of(context).sensors,
                  subtitle: S.of(context).manageYourSensors,
                  onTap: () {
                    context.push(SensorsScreen());
                  },
                ),
                BuildItem(
                  icon: Icons.auto_awesome,
                  title: S.of(context).automations,
                  subtitle: S.of(context).manageYourAutomations,
                  onTap: () {
                    context.push(AllAutomationsScreen());
                  },
                ),
                BuildItem(
                  icon: Icons.door_back_door_outlined,
                  title: S.of(context).rooms,
                  subtitle: S.of(context).manageYourRooms,
                  onTap: () {
                    context.push(RoomsScreen());
                  },
                ),
                BlocConsumer<DashboardBloc, DashboardState>(
                  listener: (context, state) {
                    if (state is GetPaymentUrlErrorState) {
                      ExceptionManager.showMessage(state.exception);
                    }
                    if (state is GetPaymentUrlSuccessState) {
                      context.push(PaymentWebView(url: state.paymentUrl));
                    }
                  },
                  buildWhen: (
                    previous,
                    current,
                  ) {
                    return current is GetPaymentUrlLoadingState ||
                        current is GetPaymentUrlSuccessState ||
                        current is GetPaymentUrlErrorState;
                  },
                  listenWhen: (
                    previous,
                    current,
                  ) {
                    return current is GetPaymentUrlErrorState ||
                        current is GetPaymentUrlSuccessState ||
                        previous is GetPaymentUrlSuccessState ||
                        previous is GetPaymentUrlErrorState;
                  },
                  builder: (context, state) {
                    return state is GetPaymentUrlLoadingState
                        ? Center(
                            child: CustomLoadingWidget(),
                          )
                        : BuildItem(
                            icon: Icons.payments,
                            title: S.of(context).payBills,
                            subtitle: S.of(context).payBillsDescription,
                            onTap: () {
                              DashboardBloc.get().add(
                                GetPaymentUrlEvent(),
                              );
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
