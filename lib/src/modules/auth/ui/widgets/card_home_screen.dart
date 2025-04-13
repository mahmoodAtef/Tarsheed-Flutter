import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class DeviceCard extends StatelessWidget {
  final IconData icon;
  final String deviceName;
  final String deviceType;
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const DeviceCard({
    required this.icon,
    required this.deviceName,
    required this.deviceType,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: isActive ? ColorManager.primary : ColorManager.white,
        // تغيير اللون بناءً على حالة isActive
        borderRadius: BorderRadius.circular(20),
        // زوايا دائرية
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Color(0xFF6F7EA8),
                  size: 24,
                ),
                FlutterSwitch(
                  width: 50,
                  height: 25,
                  toggleSize: 20,
                  value: isActive,
                  borderRadius: 30,
                  padding: 2,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                  onToggle: onToggle,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              deviceName,
              style: TextStyle(
                color: Color(0xFF6F7EA8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              deviceType,
              style: TextStyle(
                color: Color(0xFF6F7EA8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
