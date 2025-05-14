import 'package:equatable/equatable.dart';

part 'device_condition.dart';
part 'sensor_condition.dart';

abstract class Condition extends Equatable {
  const Condition();

  factory Condition.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'DEVICE':
        return DeviceCondition.fromJson(json);
      case 'SENSOR':
        return SensorCondition.fromJson(json);
      default:
        return DeviceCondition.fromJson(json);
    }
  }
  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [];
}
