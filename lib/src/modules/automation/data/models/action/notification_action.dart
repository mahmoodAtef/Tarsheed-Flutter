part of 'action.dart';

class NotificationAction extends AutomationAction {
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
  @override
  Map<String, dynamic> toJson() => {
        "type": "NOTIFICATION",
        "data": {"title": title, "message": message}
      };
  @override
  List<Object?> get props => [title, message];
}
