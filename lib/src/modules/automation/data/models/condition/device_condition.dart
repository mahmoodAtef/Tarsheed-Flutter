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
        deviceID: json["deviceId"],
        state: json["state"] == "turned_on"
            ? 1
            : json["state"] == "turned_off"
                ? 0
                : -1,
      );

  @override
  Map<String, dynamic> toJson() => {
        "type": "DEVICE",
        "deviceId": deviceID,
        "state": state,
      };
}
