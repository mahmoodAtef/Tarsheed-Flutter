import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/bottom_navigator_bar.dart';
import '../widgets/container_with_switch.dart';

class EnergyModePage extends StatelessWidget {
  const EnergyModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigator(),
      appBar: CustomAppBar(text: S.of(context).energyMode),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            CustomContainer(
              text: S.of(context).energySavingMode,
              status: false,
            ),
            SizedBox(height: 15.h),
            CustomContainer(
              text: S.of(context).superEnergySavingMode,
              status: true,
            ),
            SizedBox(height: 15.h),
            CustomContainer(
              text: S.of(context).sleepMode,
              status: false,
            ),
          ],
        ),
      ),
    );
  }
}
