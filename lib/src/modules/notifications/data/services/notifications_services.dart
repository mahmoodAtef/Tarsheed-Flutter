import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/notifications/data/models/app_notification.dart';
import 'package:tarsheed/src/modules/notifications/data/services/base_notifications_services.dart';

class NotificationsRemoteService extends BaseNotificationsService {
  static final _messaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();
  static bool _isFlutterLocalNotificationsInitialized = false;

  //  Firebase Background Handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await setupFlutterNotifications();
    await showNotification(message);
  }

  //  Initialization
  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _setupMessageHandlers();

    if (ApiManager.userId != null) {
      await _updateToken();
    }

    await setupFlutterNotifications();
  }

  static Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
  }

  static Future<void> _setupMessageHandlers() async {
    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // Background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // App opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  static void _handleBackgroundMessage(RemoteMessage message) {
    // Implement navigation or logic on message tap if needed
  }

  //  Firebase Token Management
  static Future<Either<Exception, Unit>> _updateToken() async {
    try {
      final String token = await getTokenFromFirebase();
      await DioHelper.postData(
        data: {'token': token},
        path: EndPoints.updateToken,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  static Future<String> getTokenFromFirebase() async {
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

  //  Local Notification Setup
  static Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsDarwin = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  //  Displaying Notifications
  static Future<void> showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  //  API Calls for Notification Data
  @override
  Future<Either<Exception, List<AppNotification>>> getNotifications() async {
    try {
      final response =
          await DioHelper.getData(path: EndPoints.getNotifications);
      final notifications = (response.data as List)
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
      await DioHelper.postData(
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
}
