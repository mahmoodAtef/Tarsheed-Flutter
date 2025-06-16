import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/notifications/data/models/app_notification.dart';
import 'package:tarsheed/src/modules/notifications/data/repositories/notifications_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._notificationRepository)
      : super(NotificationsInitial());
  final NotificationsRepository _notificationRepository;

  static NotificationsCubit get() {
    if (sl<NotificationsCubit>().isClosed) {
      sl.unregister<NotificationsCubit>();
      sl.registerLazySingleton<NotificationsCubit>(
        () => NotificationsCubit(sl<NotificationsRepository>()),
      );
    }
    return sl<NotificationsCubit>();
  }

  Future<void> getNotifications() async {
    List<AppNotification> notifications = state.notifications;
    emit(GetNotificationsLoadingState(notifications: notifications));
    final result = await _notificationRepository.getNotifications();
    result.fold((l) {
      emit(GetNotificationsErrorState(
          exception: l, notifications: notifications));
    }, (r) {
      emit(GetNotificationsSuccessState(
        notifications: r,
      ));
    });
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    List<AppNotification> notifications = state.notifications;
    emit(MarkNotificationAsReadLoadingState(notifications: notifications));
    final result =
        await _notificationRepository.markNotificationAsRead(notificationId);
    result.fold((l) {
      emit(MarkNotificationAsReadErrorState(
          exception: l, notifications: notifications));
    }, (r) {
      emit(MarkNotificationAsReadSuccessState(
          notificationId: notificationId, notifications: notifications));
    });
  }

  Future<void> markAllNotificationsAsRead() async {
    List<AppNotification> notifications = state.notifications;
    emit(MarkAllNotificationsAsReadLoadingState(notifications: notifications));
    final result = await _notificationRepository.markAllNotificationsAsRead();
    result.fold((l) {
      emit(MarkAllNotificationsAsReadErrorState(
          exception: l, notifications: notifications));
    }, (r) {
      emit(
          MarkAllNotificationsAsReadSuccessState(notifications: notifications));
    });
  }
}
