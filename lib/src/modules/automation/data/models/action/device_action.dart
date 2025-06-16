part of 'action.dart';

class DeviceAction extends AutomationAction {
  final String deviceId;
  final String state;

  const DeviceAction({
    required this.deviceId,
    required this.state,
  });

  factory DeviceAction.fromJson(Map<String, dynamic> json) => DeviceAction(
        deviceId: json['data']['deviceId'] is Map
            ? json['data']['deviceId']['_id'] ?? ''
            : json['data']['deviceId'] ?? '',
        state: json['data']['state'] == "ON" ? "turned_on" : "turned_off",
      );

  @override
  Map<String, dynamic> toJson() => {
        "type": "DEVICE",
        "data": {"deviceId": deviceId, "state": state}
      };
  @override
  List<Object?> get props => [deviceId, state];
}
