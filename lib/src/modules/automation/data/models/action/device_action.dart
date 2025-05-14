part of 'action.dart';

class DeviceAction extends Action {
  final String deviceId;
  final String state;

  const DeviceAction({
    required this.deviceId,
    required this.state,
  });

  factory DeviceAction.fromJson(Map<String, dynamic> json) => DeviceAction(
        deviceId: json['device_id'],
        state: json['state'],
      );
  Map<String, dynamic> toJson() => {
        "type": "DEVICE",
        "data": {"deviceId": deviceId, "state": state}
      };
  @override
  List<Object?> get props => [deviceId, state];
}
