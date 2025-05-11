import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/utils/color_manager.dart';
import '../../data/models/consumption_interval.dart';

class UsageChartWidget extends StatelessWidget {
  final List<ConsumptionInterval> chartData;
  const UsageChartWidget({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270.h,
      child: Card(
        color: ColorManager.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(10.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Usage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.black,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: SfCartesianChart(
                    primaryXAxis: NumericAxis(
                      minimum: 0,
                      maximum: 30,
                      interval: 3,
                      title: AxisTitle(text: ''),
                      labelStyle: TextStyle(color: ColorManager.black),
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: getMaxValue(chartData) ?? 300,
                      interval: 50,
                      title: AxisTitle(text: ''),
                      labelStyle: TextStyle(color: ColorManager.black),
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
                        color: ColorManager.primary,
                        width: 2,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          color: ColorManager.primary,
                          width: 6,
                          height: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'kWh',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.black,
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
