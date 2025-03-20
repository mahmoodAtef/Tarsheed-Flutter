import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

import '../../../../../generated/l10n.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/container_with_switch.dart';

class EnergyModePage extends StatelessWidget {
  const EnergyModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
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
