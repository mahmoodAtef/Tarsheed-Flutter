part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  final List<AppNotification> notifications;
  const NotificationsState({this.notifications = const <AppNotification>[]});
}

final class NotificationsInitial extends NotificationsState {
  @override
  List<Object> get props => [];
}

class GetNotificationsLoadingState extends NotificationsState {
  const GetNotificationsLoadingState({super.notifications});
  @override
  List<Object> get props => [];
}

class GetNotificationsSuccessState extends NotificationsState {
  const GetNotificationsSuccessState({required super.notifications});
  @override
  List<Object> get props => [notifications];
}

class GetNotificationsErrorState extends NotificationsState {
  final Exception exception;

  const GetNotificationsErrorState(
      {required this.exception, super.notifications});

  @override
  List<Object> get props => [exception, notifications];
}

class MarkNotificationAsReadLoadingState extends NotificationsState {
  const MarkNotificationAsReadLoadingState({super.notifications});
  @override
  List<Object> get props => [];
}

class MarkNotificationAsReadSuccessState extends NotificationsState {
  final String notificationId;

  const MarkNotificationAsReadSuccessState(
      {required this.notificationId, super.notifications});

  @override
  List<Object> get props => [notificationId, notifications];
}

class MarkNotificationAsReadErrorState extends NotificationsState {
  final Exception exception;

  const MarkNotificationAsReadErrorState(
      {required this.exception, super.notifications});

  @override
  List<Object> get props => [exception, notifications];
}

class MarkAllNotificationsAsReadLoadingState extends NotificationsState {
  const MarkAllNotificationsAsReadLoadingState({super.notifications});
  @override
  List<Object> get props => [];
}

class MarkAllNotificationsAsReadSuccessState extends NotificationsState {
  const MarkAllNotificationsAsReadSuccessState({super.notifications});
  @override
  List<Object> get props => [notifications];
}

class MarkAllNotificationsAsReadErrorState extends NotificationsState {
  final Exception exception;

  const MarkAllNotificationsAsReadErrorState(
      {required this.exception, super.notifications});

  @override
  List<Object> get props => [exception, notifications];
}
