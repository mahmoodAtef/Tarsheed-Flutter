import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_usage.dart';

final class Report extends Equatable {
  final double totalConsumption;
  final double savingsPercentage;
  final double previousConsumption;
  final List<DeviceUsage> devicesUsages;
  final DateTime updatedAt;
  final int? period;
  const Report(
      {required this.devicesUsages,
      required this.totalConsumption,
      required this.savingsPercentage,
      required this.updatedAt,
      required this.previousConsumption,
      this.period});
  factory Report.fromJson(Map<String, dynamic> json) => Report(
      savingsPercentage: double.tryParse(json["savingsPercentage"]) ?? 0,
      totalConsumption: double.tryParse(json["totalConsumption"]) ?? 0,
      period: json["period"],
      previousConsumption:
          double.tryParse(json["previousPeriodConsumption"]) ?? 0,
      devicesUsages:
          List.of(json["devices"].map((e) => DeviceUsage.fromJson(e))),
      updatedAt: json["updatedAt"] ?? DateTime.now());

  factory Report.empty() => Report(
        devicesUsages: [],
        totalConsumption: 0,
        savingsPercentage: 0,
        updatedAt: DateTime.now(),
        previousConsumption: 0,
      );

  Map<String, dynamic> toJson() => {
        "savingsPercentage": savingsPercentage,
        "totalConsumption": totalConsumption,
        "previousPeriodConsumption": previousConsumption,
        "updatedAt": updatedAt.toIso8601String(),
        "period": period,
        "devices": devicesUsages.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        devicesUsages,
        totalConsumption,
        devicesUsages,
        previousConsumption,
        savingsPercentage,
        period
      ];
}
