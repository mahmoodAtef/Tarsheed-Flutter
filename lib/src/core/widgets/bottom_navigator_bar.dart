import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => current is SelectPageState,
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: SettingsCubit.get().currentPageIndex,
            onTap: (val) {
              SettingsCubit.get().changeIndex(val);
            },
            type: theme.bottomNavigationBarTheme.type ??
                BottomNavigationBarType.fixed,
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
            unselectedItemColor:
                theme.bottomNavigationBarTheme.unselectedItemColor,
            selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
            elevation: theme.bottomNavigationBarTheme.elevation ?? 8,
            iconSize: 24.sp,
            selectedLabelStyle:
                theme.bottomNavigationBarTheme.selectedLabelStyle,
            unselectedLabelStyle:
                theme.bottomNavigationBarTheme.unselectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                activeIcon: Icon(Icons.home),
                label: "",
                tooltip: S.of(context).home,
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  tooltip: S.of(context).reports,
                  label: ""),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: "",
                tooltip: S.of(context).notifications,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: "",
                tooltip: S.of(context).settings,
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_customize_outlined),
                  activeIcon: Icon(Icons.dashboard_customize),
                  tooltip: S.of(context).myHome,
                  label: ""),
            ],
          );
        },
      ),
    );
  }
}
