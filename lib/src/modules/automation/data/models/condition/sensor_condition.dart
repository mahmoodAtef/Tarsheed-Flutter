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
        sensorID: json["sensorId"].toString(),
        state: int.tryParse(json["sensorValue"].toString()) ?? -1,
      );
  Map<String, dynamic> toJson() => {
        "type": "SENSOR",
        "sensorId": sensorID,
        "sensorValue": state,
      };
}
/*


 */
