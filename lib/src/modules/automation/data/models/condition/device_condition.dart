part of 'condition.dart';

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

  @override
  Map<String, dynamic> toJson() => {
        "type": "DEVICE",
        "deviceId": deviceID,
        "state": state,
      };
}
