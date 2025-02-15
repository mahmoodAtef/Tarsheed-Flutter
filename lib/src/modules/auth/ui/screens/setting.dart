import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/generated/l10n.dart'; // استيراد ملف الترجمة
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/container_with_switch.dart';
import 'energy_mode.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      backgroundColor: Colors.white,
      appBar: CustomAppBar(text: S.of(context).settings), // استخدام الترجمة
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            CustomContainer(
              text: S.of(context).language, // استخدام الترجمة
            ),
            CustomContainer(
              text: S.of(context).backup_settings, // استخدام الترجمة
            ),
            CustomContainer(
              text: S.of(context).energy_mode, // استخدام الترجمة
              icon: Icons.arrow_forward_ios,
              onpressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EnergyModePage()));
              },
            ),
            CustomContainer(
              text: S.of(context).software_update, // استخدام الترجمة
            ),
            CustomContainer(
              text: S.of(context).help_and_support, // استخدام الترجمة
            ),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {},
              child: Center(
                child: Text(
                  S.of(context).delete_my_account, // استخدام الترجمة
                  style: TextStyle(
                    fontSize: 16,
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
