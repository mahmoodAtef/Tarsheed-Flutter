import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
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
              text: S.of(context).backup_settings,
            ),
            CustomContainer(
              text: S.of(context).energy_mode,
              icon: Icons.arrow_forward_ios,
              onpressed: () {
                context.push(EnergyModePage());
              },
            ),
            CustomContainer(
              text: S.of(context).software_update,
            ),
            CustomContainer(
              text: S.of(context).help_and_support,
            ),
            SizedBox(height: 5.h),
            TextButton(
              onPressed: () {},
              child: Center(
                child: Text(
                  S.of(context).delete_my_account,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
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
