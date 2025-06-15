import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/src/core/widgets/bottom_navigator_bar.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/reports_cubit/reports_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/home_dashboard_screen.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/home_screen.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/reports_page.dart';
import 'package:tarsheed/src/modules/notifications/cubit/notifications_cubit.dart';
import 'package:tarsheed/src/modules/notifications/ui/screens/notification_page.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/setting.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReportsCubit.get(),
        ),
        BlocProvider(
          create: (context) => DevicesCubit.get(),
        ),
        BlocProvider(
          create: (context) => DashboardBloc.get(),
        ),
        BlocProvider(
          create: (context) => NotificationsCubit.get(),
        ),
      ],
      child: Scaffold(
          body: BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                current is SelectPageState || current is SettingsInitial,
            builder: (context, state) {
              return pages[context.read<SettingsCubit>().currentPageIndex];
            },
          ),
          bottomNavigationBar: BottomNavigator()),
    );
  }

  final List<Widget> pages = const [
    HomeScreen(),
    ReportsPage(),
    NotificationPage(),
    SettingPage(),
    DashBoardScreen()
  ];
}
