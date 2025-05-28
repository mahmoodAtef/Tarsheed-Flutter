import 'package:flutter/material.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/sensors_screen.dart';

import '../../../../core/utils/color_manager.dart';

class FilterTabsRow extends StatelessWidget {
  const FilterTabsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterTab(
          label: S.of(context).consumption,
          isActive: true,
          onTap: () {},
        ),
        const SizedBox(width: 10),
        FilterTab(
          label: S.of(context).rooms,
          isActive: false,
          onTap: () {},
        ),
        const SizedBox(width: 10),
        FilterTab(
          label: S.of(context).priority,
          isActive: false,
          onTap: () {},
        ),
        const SizedBox(width: 10),
        FilterTab(
          label: S.of(context).sensors,
          isActive: false,
          onTap: () {
            context.push(SensorsScreen());
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
