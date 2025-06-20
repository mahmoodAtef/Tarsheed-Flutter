import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/widgets/appbar.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/notifications/cubit/notifications_cubit.dart';
import 'package:tarsheed/src/modules/notifications/ui/widgets/notification_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => NotificationsCubit.get()..getNotifications(),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: ConnectionWidget(
          onRetry: () => _handleRetry(),
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: _buildNotificationsList(context, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      text: S.of(context).notifications,
      withBackButton: false,
    );
  }

  Widget _buildNotificationsList(BuildContext context, ThemeData theme) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _buildStateContent(context, state, theme),
        );
      },
    );
  }

  Widget _buildStateContent(
      BuildContext context, NotificationsState state, ThemeData theme) {
    if (state is GetNotificationsLoadingState) {
      return Center(
        child: CustomLoadingWidget(),
      );
    } else if (state is GetNotificationsSuccessState) {
      return state.notifications.isNotEmpty
          ? _buildNotificationsListView(context, state.notifications, theme)
          : _buildEmptyState(context, theme);
    } else if (state is GetNotificationsErrorState) {
      ExceptionManager.showMessage(state.exception);
    }
    return _buildInitialState(theme);
  }

  Widget _buildLoadingState(ThemeData theme, context) {
    return Container(
      key: const ValueKey('loading'),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoadingWidget(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsListView(
    BuildContext context,
    List notifications,
    ThemeData theme,
  ) {
    return Container(
      key: const ValueKey('notifications_list'),
      child: RefreshIndicator(
        onRefresh: () async => _handleRefresh(),
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildDismissibleNotification(
              context,
              notification,
              index,
              theme,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDismissibleNotification(
    BuildContext context,
    dynamic notification,
    int index,
    ThemeData theme,
  ) {
    return Dismissible(
      key: Key('notification_${notification.id}_$index'),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(theme, false, context),
      secondaryBackground: _buildDismissBackground(theme, true, context),
      onDismissed: (direction) => _handleNotificationDismissed(notification.id),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: NotificationWidget(
          notification: notification,
        ),
      ),
    );
  }

  Widget _buildDismissBackground(
      ThemeData theme, bool isSecondary, BuildContext context) {
    return Container(
      alignment: isSecondary ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: isSecondary ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment:
            isSecondary ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete_outline,
            color: theme.colorScheme.error,
            size: 24.r,
          ),
          SizedBox(width: 8.w),
          Text(
            S.of(context).markAsRead ?? 'Mark as read',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      key: const ValueKey('empty_state'),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: NoDataWidget(),
        ),
      ),
    );
  }

  Widget _buildInitialState(ThemeData theme) {
    return Container(
      key: const ValueKey('initial_state'),
      child: Center(
        child: CustomLoadingWidget(),
      ),
    );
  }

  void _handleRetry() {
    NotificationsCubit.get().getNotifications();
  }

  Future<void> _handleRefresh() async {
    NotificationsCubit.get().getNotifications();
  }

  void _handleNotificationDismissed(String notificationId) {
    NotificationsCubit.get().markNotificationAsRead(notificationId);
  }
}
