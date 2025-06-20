part of 'condition.dart';

class SensorCondition extends Condition {
  final String sensorID;
  final int state;
  final String operator;
  const SensorCondition(
      {required this.sensorID, required this.state, required this.operator});

  factory SensorCondition.fromJson(Map<String, dynamic> json) =>
      SensorCondition(
          sensorID: json["sensorId"].toString(),
          state: int.tryParse(json["sensorValue"].toString()) ?? -1,
          operator: json["operator"] ?? "=");
  Map<String, dynamic> toJson() => {
        "type": "SENSOR",
        "sensorId": sensorID,
        "sensorValue": state,
        "operator": operator
      };
}
