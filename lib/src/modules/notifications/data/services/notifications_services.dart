import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/notifications/data/models/app_notification.dart';
import 'package:tarsheed/src/modules/notifications/data/services/base_notifications_services.dart';

class NotificationsRemoteService extends BaseNotificationsService {
  @override
  Future<Either<Exception, List<AppNotification>>> getNotifications() async {
    try {
      final response =
          await DioHelper.getData(path: EndPoints.getNotifications);
      final List<AppNotification> notifications = (response.data as List)
          .map((e) => AppNotification.fromJson(e))
          .toList();
      return Right(notifications);
    } on DioException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> markAllNotificationsAsRead() async {
    try {
      await DioHelper.postData(
        data: {},
        path: EndPoints.markAllNotificationsAsRead,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> markNotificationAsRead(
      String notificationId) async {
    try {
      DioHelper.postData(
        data: {},
        path: EndPoints.markNotificationAsRead,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> updateToken() async {
    try {
      final String token = await getTokenFromFirebase();

      await DioHelper.postData(
        data: {
          'token': token,
        },
        path: EndPoints.updateToken,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<String> getTokenFromFirebase() async {
    try {
      await FirebaseMessaging.instance.requestPermission();
      final String? token = await FirebaseMessaging.instance.getToken();
      return token ?? '';
    } on DioException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }
}
