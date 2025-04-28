import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import '../../../../core/utils/color_manager.dart';

class FilterTabsRow extends StatelessWidget {
  const FilterTabsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterTab(
          label: 'Consumption',
          isActive: true,
          onTap: () {
          },
        ),
        const SizedBox(width: 10),
        FilterTab(
          label: 'Rooms',
          isActive: false,
          onTap: () {

          },
        ),
        const SizedBox(width: 10),
        FilterTab(
          label: 'Priority',
          isActive: false,
          onTap: () {

          },
        ),
      ],
    );
  }
}

class FilterTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FilterTab({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? ColorManager.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
