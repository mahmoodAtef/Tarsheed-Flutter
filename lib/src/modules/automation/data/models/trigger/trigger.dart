import 'package:equatable/equatable.dart';

part 'schedule_trigger.dart';
part 'sensor_trigger.dart';

abstract class Trigger extends Equatable {
  const Trigger();

  factory Trigger.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case "SCHEDULE":
        return ScheduleTrigger.fromJson(json);
      case "SENSOR":
        return SensorTrigger.fromJson(json);
      default:
        return ScheduleTrigger.fromJson(json);
    }
  }
  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [];

  factory Trigger.empty() {
    return ScheduleTrigger(
      time: "10:00",
    );
  }
}
