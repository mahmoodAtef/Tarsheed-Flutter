part of 'action.dart';

class DeviceAction extends AutomationAction {
  final String deviceId;
  final String state;

  const DeviceAction({
    required this.deviceId,
    required this.state,
  });

  factory DeviceAction.fromJson(Map<String, dynamic> json) => DeviceAction(
        deviceId: json['device_id'].toString(),
        state: json['state'] == "turned_on" ? "turned_on" : "turned_off",
      );

  @override
  Map<String, dynamic> toJson() => {
        "type": "DEVICE",
        "data": {"deviceId": deviceId, "state": state}
      };
  @override
  List<Object?> get props => [deviceId, state];
}
