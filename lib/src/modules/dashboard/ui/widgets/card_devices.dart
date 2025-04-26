import 'package:flutter/material.dart';
import '../../../../core/utils/color_manager.dart';
import '../../data/models/device.dart'; // اتأكد انك مستورد الموديل بتاع Device

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback? onEdit;
  final ValueChanged<bool> onToggle;

  const DeviceCard({
    Key? key,
    required this.device,
    this.onEdit,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = device.state ? Colors.white : Colors.black;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: device.state ? ColorManager.primary : Colors.grey.shade200,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.electrical_services,
                size: 40,
                color: textColor,
              ),
              const SizedBox(height: 10),
              Text(
                device.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                device.description,
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                'Room: ${device.roomId}',
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Category: ${device.categoryId}',
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                'Consumption: ${device.consumption.toStringAsFixed(2)} W',
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.8),
                ),
              ),
              Text(
                'Priority: ${device.priority}',
                style: TextStyle(
                  fontSize: 10,
                  color: textColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Switch(
                value: device.state,
                onChanged: onToggle,
                activeColor: Colors.white,
              ),
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
                  color: device.state ? Colors.white24 : Colors.grey.shade300,
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
