import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/widgets/appbar.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
