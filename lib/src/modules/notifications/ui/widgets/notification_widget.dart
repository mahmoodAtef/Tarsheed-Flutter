import 'package:flutter/material.dart';
import 'package:tarsheed/src/modules/notifications/data/models/app_notification.dart';

class NotificationWidget extends StatelessWidget {
  final AppNotification notification;
  const NotificationWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification.title),
      subtitle: Text(notification.body),
    );
  }
}
