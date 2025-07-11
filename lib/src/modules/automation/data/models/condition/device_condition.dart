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
        deviceID: json["deviceId"]["_id"] ?? json["deviceId"] ?? '',
        state: json["state"] == "ON"
            ? 1
            : json["state"] == "OFF"
                ? 0
                : -1,
      );

  @override
  Map<String, dynamic> toJson() => {
        "type": "DEVICE",
        "deviceId": deviceID,
        "deviceState": state == 1
            ? "ON"
            : state == 0
                ? "OF"
                : "unknown",
      };
}
