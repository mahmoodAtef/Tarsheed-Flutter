import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_usage.dart';

final class Report extends Equatable {
  final double totalConsumption;
  final int savingsPercentage;
  final List<DeviceUsage> devicesUsages;

  const Report({
    required this.devicesUsages,
    required this.totalConsumption,
    required this.savingsPercentage,
  });
  factory Report.fromJson(Map<String, dynamic> json) => Report(
      savingsPercentage: int.tryParse(json["savingsPercentage"]) ?? -1,
      totalConsumption: double.tryParse(json["totalConsumption"]) ?? 0,
      devicesUsages:
          List.of(json["devices"].map((e) => DeviceUsage.fromJson(e))));

  Map<String, dynamic> toJson() => {
        "savingsPercentage": savingsPercentage,
        "totalConsumption": totalConsumption,
        "devices": devicesUsages,
      };

  @override
  List<Object?> get props => [devicesUsages, totalConsumption, devicesUsages];
}
