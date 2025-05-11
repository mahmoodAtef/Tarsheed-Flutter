import 'package:equatable/equatable.dart';

class Action extends Equatable {
  const Action();

  factory Action.fromJson(Map<String, dynamic> json) => Action();
  Map<String, dynamic> toJson() => {};
  @override
  List<Object?> get props => [];
}

class NotificationAction extends Action {
  final String title;
  final String message;

  const NotificationAction({
    required this.title,
    required this.message,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) =>
      NotificationAction(
        title: json['title'],
        message: json['message'],
      );
  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
      };
  @override
  List<Object?> get props => [title, message];
}

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
        "device_id": deviceId,
        "state": state,
      };
  @override
  List<Object?> get props => [deviceId, state];
}
