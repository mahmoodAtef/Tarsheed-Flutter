import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(text: S.of(context).energy_mode),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            CustomContainer(
              text: S.of(context).energy_saving_mode,
              status: false,
            ),
            CustomContainer(
              text: S.of(context).super_energy_saving_mode,
              status: true,
            ),
            CustomContainer(
              text: S.of(context).sleep_mode,
              status: false,
            ),
          ],
        ),
      ),
    );
  }
}
