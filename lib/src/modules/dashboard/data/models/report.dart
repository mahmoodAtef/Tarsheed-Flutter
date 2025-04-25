import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/consumption_interval.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_usage.dart';

final class Report extends Equatable {
  final double totalConsumption;
  final double savingsPercentage;
  final double consumptionCost;
  final List<ConsumptionInterval> consumptionIntervals;
  final double averageConsumption;
  final double averageCost;
  final double previousTotalConsumption;
  final List<DeviceUsage> devicesUsages;
  final DateTime updatedAt;
  final int? period;
  final int tier;
  const Report(
      {required this.devicesUsages,
      required this.totalConsumption,
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
        savingsPercentage: double.tryParse(json["savingsPercentage"]) ?? 0,
        totalConsumption: double.tryParse(json["totalConsumption"]) ?? 0,
        period: json["period"],
        averageConsumption: json["averageConsumption"],
        averageCost: json["averageCost"],
        consumptionCost: json["consumptionCost"],
        previousTotalConsumption:
            double.tryParse(json["previousPeriodConsumption"]) ?? 0,
        tier: json["Tier"],
        devicesUsages:
            List.of(json["devices"].map((e) => DeviceUsage.fromJson(e))),
        updatedAt: json["updatedAt"] ?? DateTime.now(),
        consumptionIntervals: List.of(json["consumptionIntervals"]
            .map((e) => ConsumptionInterval.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        "savingsPercentage": savingsPercentage,
        "totalConsumption": totalConsumption,
        "updatedAt": updatedAt.toIso8601String(),
        "period": period,
        "devices": devicesUsages.map((e) => e.toJson()).toList(),
        "averageConsumption": averageConsumption,
        "averageCost": averageCost,
        "consumptionCost": consumptionCost,
        "previousPeriodConsumption": previousTotalConsumption,
        "Tier": tier,
        "consumptionIntervals":
            consumptionIntervals.map((e) => e.toJson()).toList()
      };

  @override
  List<Object?> get props => [
        devicesUsages,
        totalConsumption,
        devicesUsages,
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
