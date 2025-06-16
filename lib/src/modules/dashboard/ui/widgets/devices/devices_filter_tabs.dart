import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class FilterTabsRow extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabSelected;

  const FilterTabsRow({
    Key? key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ColorManager.grey300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildTab(context, 'Consumption', 0),
          _buildTab(context, 'Rooms', 1),
          _buildTab(context, 'Priority', 2),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final isSelected = selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : ColorManager.darkGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
