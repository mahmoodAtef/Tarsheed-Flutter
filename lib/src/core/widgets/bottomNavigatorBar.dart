import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/home_screen.dart';
import '../../modules/settings/ui/screens/account_screan.dart';
import '../../modules/dashboard/ui/screens/reports_page.dart';
import '../../modules/settings/ui/screens/setting.dart';

class BottomNavigator extends StatefulWidget {
  final int currentIndex;

  const BottomNavigator({super.key, required this.currentIndex});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex >= 0 && widget.currentIndex < 5
            ? widget.currentIndex
            : 0,
        onTap: (val) {
          setState(() {
            if (val == 0) {
              context.push(HomeScreen());
            } else if (val == 1) {
              context.push(const ReportsPage());
            } else if (val == 3) {
              context.push(SettingPage());
            } else if (val == 4) {
              context.push(AccountPage());
            }
          });
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
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}
