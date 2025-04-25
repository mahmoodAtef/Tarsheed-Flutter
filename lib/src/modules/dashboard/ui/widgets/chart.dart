import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/consumption_interval.dart';

class UsageChartWidget extends StatelessWidget {
  final List<ConsumptionInterval> chartData = [
    ConsumptionInterval(1, 50),
    ConsumptionInterval(2, 150),
    ConsumptionInterval(3, 80),
    ConsumptionInterval(4, 120),
    ConsumptionInterval(5, 60),
    ConsumptionInterval(6, 90),
    ConsumptionInterval(7, 70),
    ConsumptionInterval(8, 110),
    ConsumptionInterval(9, 130),
    ConsumptionInterval(10, 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Usage',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.black),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  minimum: 1,
                  maximum: 10,
                  interval: 1,
                  title: AxisTitle(text: ''),
                  labelStyle: const TextStyle(color: Colors.black),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 200,
                  interval: 50,
                  title: AxisTitle(text: 'kWh'),
                  labelStyle: TextStyle(color: ColorManager.black),
                ),
                plotAreaBorderWidth: 0,
                enableAxisAnimation: true,
                series: <CartesianSeries<ConsumptionInterval, double>>[
                  SplineSeries<ConsumptionInterval, double>(
                    dataSource: chartData,
                    xValueMapper: (ConsumptionInterval data, _) => data.day,
                    yValueMapper: (ConsumptionInterval data, _) =>
                        data.averageUsage,
                    color: ColorManager.primary,
                    width: 2,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      color: Colors.blue,
                      width: 6,
                      height: 6,
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
