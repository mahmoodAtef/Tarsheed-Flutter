import 'package:equatable/equatable.dart';

class Condition extends Equatable {
  const Condition();

  factory Condition.fromJson(Map<String, dynamic> json) => Condition();
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [];
}

class DeviceCondition extends Condition {
  final String deviceID;
  final int state;

  const DeviceCondition({
    required this.deviceID,
    required this.state,
  });

  factory DeviceCondition.fromJson(Map<String, dynamic> json) =>
      DeviceCondition(
        deviceID: json["device_id"],
        state: json["state"],
      );
  Map<String, dynamic> toJson() => {
        "device_id": deviceID,
        "state": state,
      };
}

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
        "sensor_id": sensorID,
        "state": state,
      };
}
/*


 */
