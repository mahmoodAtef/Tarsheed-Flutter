part of 'trigger.dart';

class SensorTrigger extends Trigger {
  final String sensorID;
  final int value;
  final String operator;
  const SensorTrigger(
      {required this.sensorID, required this.value, required this.operator});

  factory SensorTrigger.fromJson(Map<String, dynamic> json) => SensorTrigger(
      sensorID: (json['sensorId'].toString()),
      value: json['value'],
      operator: json['operator'] ?? "=");
  Map<String, dynamic> toJson() => {
        "type": "SENSOR",
        'sensorId': sensorID,
        'value': value,
        "operator": operator
      };
}
