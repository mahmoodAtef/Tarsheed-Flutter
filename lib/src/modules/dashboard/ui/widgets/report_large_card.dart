import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class BuildInfoCard extends StatelessWidget {
  final Widget? iconWidget;
  final IconData? icon;
  final String? title;
  final String? value;
  final String? percentage;
  final bool? isDecrease;
  final Color? color;
  final String? roomName;

  const BuildInfoCard({
    this.iconWidget,
    this.icon,
    required this.title,
    required this.value,
    this.percentage,
    this.isDecrease,
    this.color,
    this.roomName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color ?? ColorManager.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: iconWidget ??
                  Icon(
                    icon ?? Icons.info,
                    color: Colors.white,
                    size: 24,
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'No Title',
                    style: const TextStyle(
                      color: ColorManager.darkGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ?? 'No Value',
                    style: const TextStyle(
                      color: ColorManager.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            if (roomName != null)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  roomName!,
                  style: const TextStyle(
                    color: ColorManager.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      (isDecrease ?? true)
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: (isDecrease ?? true)
                          ? (color ?? ColorManager.primary)
                          : ColorManager.red,
                      size: 20,
                      weight: 800,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      percentage ?? '0%',
                      style: TextStyle(
                        color: (isDecrease ?? true)
                            ? (color ?? ColorManager.primary)
                            : ColorManager.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
