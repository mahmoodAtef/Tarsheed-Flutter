import 'package:flutter/material.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/appbar.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/card_item.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/all_automations_screen.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/devices/devices.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/rooms_screen.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/sensors_screen.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(
          text: S.of(context).myHome,
          withBackButton: false,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                BuildItem(
                  icon: Icons.devices,
                  title: S.of(context).devices,
                  subtitle: S.of(context).manageYourDevices,
                  onTap: () {
                    context.push(DevicesScreen());
                  },
                ),
                BuildItem(
                  icon: Icons.sensors,
                  title: S.of(context).sensors,
                  subtitle: S.of(context).manageYourSensors,
                  onTap: () {
                    context.push(SensorsScreen());
                  },
                ),
                BuildItem(
                  icon: Icons.auto_awesome,
                  title: S.of(context).automations,
                  subtitle: S.of(context).manageYourAutomations,
                  onTap: () {
                    context.push(AllAutomationsScreen());
                  },
                ),
                BuildItem(
                  icon: Icons.door_back_door_outlined,
                  title: S.of(context).rooms,
                  subtitle: S.of(context).manageYourRooms,
                  onTap: () {
                    context.push(RoomsScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
