import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({
    super.key,
  });

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  Widget build(BuildContext context) {
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
            type: BottomNavigationBarType.fixed,
            backgroundColor: ColorManager.white,
            unselectedItemColor: ColorManager.grey300,
            selectedItemColor: ColorManager.primary,
            elevation: 10,
            iconSize: 24.sp,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_customize_outlined), label: ""),
            ],
          );
        },
      ),
    );
  }
}
