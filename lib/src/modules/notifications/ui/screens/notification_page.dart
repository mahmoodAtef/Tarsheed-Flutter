import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/widgets/appbar.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/notifications/cubit/notifications_cubit.dart';

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
              child: SizedBox(
                height: 120.h,
                child: NoDataWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
