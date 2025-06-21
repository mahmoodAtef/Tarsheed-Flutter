import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tarsheed/generated/l10n.dart';

import '../../../data/models/consumption_interval.dart';

class UsageChartWidget extends StatelessWidget {
  final List<ConsumptionInterval> chartData;
  const UsageChartWidget({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 270.h,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).montlyUsage,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: SizedBox(
                  height: 200.h,
                  child: SfCartesianChart(
                    primaryXAxis: NumericAxis(
                      minimum: 0,
                      maximum: 30,
                      interval: 3,
                      title: AxisTitle(text: ''),
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: getMaxValue(chartData) ?? 300,
                      interval: 50,
                      title: AxisTitle(text: ''),
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    plotAreaBorderWidth: 0,
                    enableAxisAnimation: true,
                    series: <CartesianSeries<ConsumptionInterval, double>>[
                      SplineSeries<ConsumptionInterval, double>(
                        dataSource: chartData,
                        xValueMapper: (ConsumptionInterval data, _) =>
                            data.day.toDouble(),
                        yValueMapper: (ConsumptionInterval data, _) =>
                            data.averageUsage,
                        color: theme.colorScheme.primary,
                        width: 2.w,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          color: theme.colorScheme.primary,
                          width: 6.w,
                          height: 6.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  'kWh', // Add this to your localization file
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? getMaxValue(List<ConsumptionInterval> data) {
    if (data.isEmpty) return null;
    return data.fold<double>(
          data.first.averageUsage,
          (maxSoFar, element) =>
              element.averageUsage > maxSoFar ? element.averageUsage : maxSoFar,
        ) +
        50;
  }
}
