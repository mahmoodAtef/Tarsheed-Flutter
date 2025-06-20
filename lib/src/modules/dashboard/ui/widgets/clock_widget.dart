import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ClockWidget extends StatefulWidget {
  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  String currentTime = '';
  String currentDate = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer =
        Timer.periodic(const Duration(minutes: 1), (_) => _updateDateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final egyptTime = DateTime.now().toUtc().add(const Duration(hours: 2));

    try {
      final timeFormatter = DateFormat('h:mm a');
      currentTime = timeFormatter.format(egyptTime);

      final dateFormatter = DateFormat('d MMM, yyyy');
      currentDate = dateFormatter.format(egyptTime);
    } catch (e) {
      final hour = egyptTime.hour % 12 == 0 ? 12 : egyptTime.hour % 12;
      final hourFormat = hour < 10 ? '0$hour' : '$hour';
      final minuteFormat = egyptTime.minute < 10
          ? '0${egyptTime.minute}'
          : '${egyptTime.minute}';
      final period = egyptTime.hour < 12 ? 'AM' : 'PM';
      currentTime = '$hourFormat:$minuteFormat $period';

      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      currentDate =
          '${egyptTime.day} ${months[egyptTime.month - 1]}, ${egyptTime.year}';
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentTime,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          currentDate,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
