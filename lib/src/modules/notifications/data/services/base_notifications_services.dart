import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/notifications/data/models/app_notification.dart';

abstract class BaseNotificationsService {
  Future<Either<Exception, List<AppNotification>>> getNotifications();

  Future<Either<Exception, Unit>> markNotificationAsRead(String notificationId);

  Future<Either<Exception, Unit>> markAllNotificationsAsRead();
}
