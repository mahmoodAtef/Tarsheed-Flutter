import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/notifications/data/models/app_notification.dart';
import 'package:tarsheed/src/modules/notifications/data/services/base_notifications_services.dart';

class NotificationsRepository {
  final BaseNotificationsService _notificationsService;
  const NotificationsRepository(this._notificationsService);
  Future<Either<Exception, List<AppNotification>>> getNotifications() async {
    return _notificationsService.getNotifications();
  }

  Future<Either<Exception, Unit>> markNotificationAsRead(
      String notificationId) async {
    return _notificationsService.markNotificationAsRead(notificationId);
  }

  Future<Either<Exception, Unit>> markAllNotificationsAsRead() async {
    return _notificationsService.markAllNotificationsAsRead();
  }
}
