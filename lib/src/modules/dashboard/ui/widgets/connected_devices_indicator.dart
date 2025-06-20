import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

import '../../../../../../generated/l10n.dart';

class ConnectedDevicesIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<DevicesCubit, DevicesState>(
      buildWhen: (previous, current) =>
          current is GetDevicesLoading ||
          current is GetDevicesSuccess ||
          current is GetDevicesError ||
          current is ToggleDeviceStatusSuccess,
      builder: (context, state) {
        return Row(
          children: [
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              " ${state.devices?.where((e) => e.state == true).length}"
              " ${S.of(context).connectedDevices} ",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 16.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        );
      },
    );
  }
}
