import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class PeriodFilter extends StatefulWidget {
  final List<String> periods;
  final int initialSelectedIndex;
  final ValueChanged<int> onPeriodChanged;

  const PeriodFilter({
    Key? key,
    required this.periods,
    this.initialSelectedIndex = 0,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<PeriodFilter> createState() => _PeriodFilterState();
}

class _PeriodFilterState extends State<PeriodFilter> {
  late int _selectedPeriodIndex;

  @override
  void initState() {
    super.initState();
    _selectedPeriodIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.periods.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriodIndex = index;
              });
              widget.onPeriodChanged(index);
            },
            child: Column(
              children: [
                Text(
                  widget.periods[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _selectedPeriodIndex == index
                        ? ColorManager.primary
                        : ColorManager.black,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _selectedPeriodIndex == index
                        ? ColorManager.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
