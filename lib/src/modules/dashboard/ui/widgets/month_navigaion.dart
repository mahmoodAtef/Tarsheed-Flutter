import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class MonthNavigator extends StatefulWidget {
  final Function(String)? onMonthChanged;

  const MonthNavigator({Key? key, this.onMonthChanged}) : super(key: key);

  @override
  State<MonthNavigator> createState() => _MonthNavigatorState();
}

class _MonthNavigatorState extends State<MonthNavigator> {
  DateTime _currentDate = DateTime.now();

  String _formatMonthYear() {
    return "${_currentDate.month}-${_currentDate.year}";
  }

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
    });

    if (widget.onMonthChanged != null) {
      widget.onMonthChanged!(_formatMonthYear());
    }
  }

  void _nextMonth() {
    setState(() {

      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
    });

    if (widget.onMonthChanged != null) {
      widget.onMonthChanged!(_formatMonthYear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        Text(
          _formatMonthYear(),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16,color: ColorManager.black),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }
}
