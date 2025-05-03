import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/bottom_navigator_bar.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../widgets/device_search_bar.dart';
import 'add_sensor_form_page.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: BackGroundRectangle()),
            Column(
              children: [
                const CustomAppBar(text: 'Sensors'),
                const SizedBox(height: 10),

                // Search Bar
                const DeviceSearchBar(),
                const SizedBox(height: 10),

                // Placeholder
                const Expanded(
                  child: Center(
                    child: Text(
                      'No sensors added.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Add Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primary,
        onPressed: () {
            context.push(AddSensorFormPage());
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigator(),
    );
  }
}
