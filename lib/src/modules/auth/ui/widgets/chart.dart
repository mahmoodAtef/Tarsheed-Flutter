import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class UsageChartWidget extends StatelessWidget {
  final List<ChartData> chartData = [
    ChartData(1, 50),
    ChartData(2, 150),
    ChartData(3, 80),
    ChartData(4, 120),
    ChartData(5, 60),
    ChartData(6, 90),
    ChartData(7, 70),
    ChartData(8, 110),
    ChartData(9, 130),
    ChartData(10, 200),
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
                series: <CartesianSeries<ChartData, double>>[
                  SplineSeries<ChartData, double>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.day,
                    yValueMapper: (ChartData data, _) => data.usage,
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

class ChartData {
  ChartData(this.day, this.usage);

  final double day;
  final double usage;
}
