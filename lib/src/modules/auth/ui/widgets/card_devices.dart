import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_manager.dart';

class DeviceCard extends StatelessWidget {
  final String icon;  // Change type to String to accept URL
  final String deviceName;
  final String deviceType;
  final bool isActive;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onEdit;

  const DeviceCard({
    required this.icon,
    required this.deviceName,
    required this.deviceType,
    required this.isActive,
    required this.onToggle,
    this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? Colors.white : Colors.black;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? ColorManager.primary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // If the icon is a URL, use Image.network to display it
              Image.network(
                icon,
                width: 40,
                height: 40,
                color: textColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.device_unknown, size: 40, color: textColor); // Fallback icon if there's an error
                },
              ),
              const SizedBox(height: 10),
              Text(
                deviceName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                deviceType,
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Switch(
                value: isActive,
                onChanged: onToggle,
                activeColor: Colors.white,
              ),
              const SizedBox(height: 16),
            ],
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white24 : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: 16,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
