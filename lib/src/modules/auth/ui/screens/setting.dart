import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(text: "Settings"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            CustomContainer(
              text: "Language",
            ),
            CustomContainer(
              text: "Backup Settings ",
            ),
            CustomContainer(
              text: "Energy Mode ",
              icon: Icons.arrow_forward_ios,
              onpressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EnergyModePage()));
              },
            ),
            CustomContainer(
              text: "Software Update ",
            ),
            CustomContainer(
              text: "Help and Support ",
            ),
            SizedBox(
              height: 5,
            ),
            TextButton(
              onPressed: () {},
              child: Center(
                child: Text(
                  'Delete My Account ',
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
    ;
  }
}
