import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/container_with_switch.dart';

class EnergyModePage extends StatelessWidget {
  const EnergyModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      backgroundColor: Colors.white,
      appBar: CustomAppBar(text: "Energy Mode"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            CustomContainer(
              text: "Energy Saving Mode",
              status: false,
            ),
            CustomContainer(
              text: "Super Energy saving Mode",
              status: true,
            ),
            CustomContainer(
              text: "Sleep Mode",
              status: false,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
