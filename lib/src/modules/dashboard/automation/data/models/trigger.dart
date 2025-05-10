import 'package:equatable/equatable.dart';

class Trigger extends Equatable {
  const Trigger();

  factory Trigger.fromJson(Map<String, dynamic> json) => Trigger();
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [];
}

class SensorTrigger extends Trigger {
  final String sensorID;
  final String value;
  const SensorTrigger({required this.sensorID, required this.value});

  factory SensorTrigger.fromJson(Map<String, dynamic> json) => SensorTrigger(
        sensorID: json['sensor_id'],
        value: json['value'],
      );
  Map<String, dynamic> toJson() => {
        'sensor_id': sensorID,
        'value': value,
      };
}

class ScheduleTrigger extends Trigger {
  final String time;
  const ScheduleTrigger({required this.time});

  factory ScheduleTrigger.fromJson(Map<String, dynamic> json) =>
      ScheduleTrigger(
        time: json['time'],
      );
  Map<String, dynamic> toJson() => {
        'time': time,
      };
}
