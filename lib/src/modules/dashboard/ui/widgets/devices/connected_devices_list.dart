import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/devices/devices.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/devices/card_devices.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/text_home_screen.dart';

import '../../../../../../generated/l10n.dart';

class ConnectedDevicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
                label: S.of(context).connectedDevices, size: 22.sp),
            TextButton.icon(
              onPressed: () => context.push(BlocProvider.value(
                value: DevicesCubit.get(),
                child: DevicesScreen(),
              )),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF366692),
              ),
              label: Text(
                S.of(context).viewAll,
                style: TextStyle(
                  color: const Color(0xFF366692),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                size: 10.sp,
                color: const Color(0xFF366692),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 175.h,
          child: BlocProvider.value(
            value: DevicesCubit.get(),
            child: BlocBuilder<DevicesCubit, DevicesState>(
              buildWhen: (previous, current) {
                return current is GetDevicesLoading ||
                    current is GetDevicesSuccess ||
                    current is GetDevicesError ||
                    current is ToggleDeviceStatusLoading ||
                    current is ToggleDeviceStatusSuccess ||
                    current is ToggleDeviceStatusError ||
                    previous.devices != current.devices;
              },
              builder: (context, state) {
                if (_checkIfDevicesLoading(state)) {
                  return const Center(child: CustomLoadingWidget());
                }

                if (_checkIfDevicesError(state)) {
                  return Center(
                    child: CustomErrorWidget(
                      height: 110.h,
                      exception: (state as GetDevicesError).exception,
                    ),
                  );
                }

                if (state.devices == null) {
                  return Center(child: NoDataWidget());
                }

                final connectedDevices = state.devices!
                    .where((device) => device.state == true)
                    .toList();

                if (connectedDevices.isEmpty) {
                  return Center(child: NoDataWidget());
                }

                final displayCount =
                    connectedDevices.length > 3 ? 3 : connectedDevices.length;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: displayCount,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final device = connectedDevices[index];
                    return DeviceCard(device: device);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _checkIfDevicesLoading(DevicesState state) {
    return (state is GetDevicesLoading && state.devices == null) ||
        state is DevicesInitial;
  }

  bool _checkIfDevicesError(DevicesState state) {
    return state is GetDevicesError;
  }
}
