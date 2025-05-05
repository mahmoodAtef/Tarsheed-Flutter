import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/consumption_interval.dart';

final class Report extends Equatable {
  final double totalConsumption;
  final double savingsPercentage;
  final double savingsCostPercentage;
  final double consumptionCost;
  final List<ConsumptionInterval> consumptionIntervals;
  final double averageConsumption;
  final double averageCost;
  final double previousTotalConsumption;
  final DateTime updatedAt;
  final int? period;
  final int tier;
  const Report(
      {required this.totalConsumption,
      required this.previousTotalConsumption,
      required this.averageConsumption,
      required this.averageCost,
      required this.consumptionCost,
      required this.savingsPercentage,
      required this.savingsCostPercentage,
      required this.updatedAt,
      this.period,
      required this.tier,
      this.consumptionIntervals = const []});

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        savingsPercentage: json["savingsPercentage"]?.toDouble() ?? 0,
        savingsCostPercentage: json["savingCostPercntage"]?.toDouble() ?? 0,
        totalConsumption: json["totalConsumption"]?.toDouble() ?? 0,
        period: json["period"],
        averageConsumption: json["averageConsumption"]?.toDouble() ?? 0,
        averageCost: json["averageCost"]?.toDouble() ?? 0,
        consumptionCost: json["consumptionCost"]?.toDouble() ?? 0,
        previousTotalConsumption:
            json["previousPeriodConsumption"]?.toDouble() ?? 0,
        tier: int.parse(
          json["Tier"],
        ),
        updatedAt: json["updatedAt"] ?? DateTime.now(),
        consumptionIntervals: json["chartData"] == null
            ? []
            : _getConsumptionIntervals(json["chartData"]),
      );

  Map<String, dynamic> toJson() => {
        "savingsPercentage": savingsPercentage,
        "totalConsumption": totalConsumption,
        "updatedAt": updatedAt.toIso8601String(),
        "period": period,
        "averageConsumption": averageConsumption,
        "averageCost": averageCost,
        "consumptionCost": consumptionCost,
        "previousPeriodConsumption": previousTotalConsumption,
        "Tier": "$tier",
        "chartData": consumptionIntervals.map((e) => e.toJson()).toList()
      };

  @override
  List<Object?> get props => [
        totalConsumption,
        savingsPercentage,
        period,
        averageConsumption,
        averageCost,
        consumptionCost,
        previousTotalConsumption,
        tier,
        consumptionIntervals
      ];
  static List<ConsumptionInterval> _getConsumptionIntervals(
      Map<String, dynamic> data) {
    List<ConsumptionInterval> intervals = [];
    data.forEach((key, value) {
      int day = double.parse(key.toString()).toInt() * 3;
      intervals.add(ConsumptionInterval(day, value.toDouble()));
    });
    return intervals;
  }
  /*
   {
      "userId": "680a9b2dcdf756b0e0909dde",
      "totalConsumption": 454,
      "consumptionCost": 432.12,
      "Tier": "5",
      "averageConsumption": 745.875,
      "averageCost": 820.1650000000001,
      "previousTotalConsumption": 802,
      "savingsPercentage": 43.39,
      "chartData": {1: 139, 2: 46, 3: 75, 4: 37, 5: 137, 6: 0, 7: 0, 8: 0, 9: 20, 10: 0}
 }
   */
}
