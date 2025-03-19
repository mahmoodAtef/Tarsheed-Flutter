import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/energy_mode.dart';

import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/container_with_switch.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      appBar: CustomAppBar(text: S.of(context).settings),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: ListView(
          children: [
            CustomContainer(
              text: S.of(context).language,
            ),
            CustomContainer(
              text: S.of(context).backupSettings,
            ),
            CustomContainer(
              text: S.of(context).energyMode,
              icon: Icons.arrow_forward_ios,
              onpressed: () {
                context.push(EnergyModePage());
              },
            ),
            CustomContainer(
              text: S.of(context).softwareUpdate,
            ),
            CustomContainer(
              text: S.of(context).helpAndSupport,
            ),
            SizedBox(height: 5.h),
            TextButton(
              onPressed: () {},
              child: Center(
                child: Text(
                  S.of(context).deleteMyAccount,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
