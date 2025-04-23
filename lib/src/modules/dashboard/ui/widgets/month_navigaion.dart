import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

import 'circle_button_month_navigator.dart';

class MonthNavigator extends StatefulWidget {
  const MonthNavigator({Key? key}) : super(key: key);

  @override
  State<MonthNavigator> createState() => _MonthNavigatorState();
}

class _MonthNavigatorState extends State<MonthNavigator> {
  DateTime _currentDate = DateTime.now();

  String _formatMonthYear() {
    final formatter = DateFormat('MMMM, yyyy');
    return formatter.format(_currentDate);
  }

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month + 1,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircularIconButton(
          icon: Icons.chevron_left,
          onPressed: _previousMonth,
        ),
        Text(
          _formatMonthYear(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: ColorManager.black,
          ),
        ),
        CircularIconButton(
          icon: Icons.chevron_right,
          onPressed: _nextMonth,
        ),
      ],
    );
  }
}
