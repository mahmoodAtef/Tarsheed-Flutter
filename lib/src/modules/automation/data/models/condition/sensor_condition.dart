part of 'condition.dart';

class SensorCondition extends Condition {
  final String sensorID;
  final int state;

  const SensorCondition({
    required this.sensorID,
    required this.state,
  });

  factory SensorCondition.fromJson(Map<String, dynamic> json) =>
      SensorCondition(
        sensorID: json["sensor_id"],
        state: json["state"],
      );
  Map<String, dynamic> toJson() => {
        "type": "SENSOR",
        "SensorId": sensorID,
        "state": state,
      };
}
