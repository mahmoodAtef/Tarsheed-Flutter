part of 'trigger.dart';

class SensorTrigger extends Trigger {
  final String sensorID;
  final int value;
  const SensorTrigger({required this.sensorID, required this.value});

  factory SensorTrigger.fromJson(Map<String, dynamic> json) => SensorTrigger(
        sensorID: json['sensor_id'],
        value: json['value'],
      );
  Map<String, dynamic> toJson() => {
        "type": "SENSOR",
        'sensorId': sensorID,
        'value': value,
      };
}
