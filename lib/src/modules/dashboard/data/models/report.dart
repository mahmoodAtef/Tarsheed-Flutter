import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/consumption_interval.dart';

final class Report extends Equatable {
  final double totalConsumption;
  final double savingsPercentage;
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
      required this.updatedAt,
      this.period,
      required this.tier,
      this.consumptionIntervals = const []});

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        savingsPercentage: json["savingsPercentage"]?.toDouble() ?? 0,
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
        consumptionIntervals: json["consumptionIntervals"] == null
            ? []
            : List.of(json["consumptionIntervals"]
                .map((e) => ConsumptionInterval.fromJson(e))),
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
        "Tier": "Tier $tier",
        "consumptionIntervals":
            consumptionIntervals.map((e) => e.toJson()).toList()
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
}
