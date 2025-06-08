import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/widgets/appbar.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/notifications/cubit/notifications_cubit.dart';
import 'package:tarsheed/src/modules/notifications/ui/widgets/notification_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationsCubit>()..getNotifications(),
      child: Column(
        children: [
          CustomAppBar(
            text: S.of(context).notifications,
            withBackButton: false,
          ),
          Expanded(
            child: Center(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is GetNotificationsLoadingState) {
                    return const CustomLoadingWidget();
                  } else if (state is GetNotificationsSuccessState ||
                      state.notifications.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return Dismissible(
                          key: Key(notification.id),
                          onDismissed: (direction) {
                            context
                                .read<NotificationsCubit>()
                                .markNotificationAsRead(notification.id);
                          },
                          child: NotificationWidget(
                            notification: notification,
                          ),
                        );
                      },
                    );
                  } else if (state is GetNotificationsErrorState) {
                    return CustomErrorWidget(exception: state.exception);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
