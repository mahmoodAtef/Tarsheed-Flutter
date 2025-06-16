import 'package:equatable/equatable.dart';

part 'device_action.dart';
part 'notification_action.dart';

abstract class AutomationAction extends Equatable {
  const AutomationAction();

  factory AutomationAction.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case "DEVICE":
        return DeviceAction.fromJson(json);
      case "NOTIFICATION":
        return NotificationAction.fromJson(json);
      default:
        return NotificationAction.fromJson(json);
    }
  }
  Map<String, dynamic> toJson();
  @override
  List<Object?> get props => [];
}
/*

 */

/*

 */
