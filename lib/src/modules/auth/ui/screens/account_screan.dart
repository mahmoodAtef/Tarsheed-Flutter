import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/profile_screen.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/security_screen.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/setting.dart';
import '../../../../../generated/l10n.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/card_item.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      appBar: CustomAppBar(text: S.of(context).account),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildItem(
              icon: Icons.person_outline,
              title: S.of(context).profile,
              subtitle: S.of(context).editPassNaAddUseEm,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            SizedBox(height: 20.h),
            BuildItem(
              icon: Icons.shield_outlined,
              title: S.of(context).security,
              subtitle: S.of(context).faceTwoStVerification,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecurityPage()),
                );
              },
            ),
            SizedBox(height: 20.h),
            BuildItem(
              icon: Icons.settings,
              title: S.of(context).settings,
              subtitle: S.of(context).lanBackEneMO,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
            SizedBox(height: 25.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(left: 3.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFEEEEEEEE), width: 3.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00000040),
                      offset: Offset(0, 4.h),
                      blurRadius: 4.r,
                    ),
                  ],
                ),
                width: double.infinity,
                height: 34.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).rateApplication,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            TextButton(
              onPressed: () {},
              child: Center(
                child: Text(
                  S.of(context).signOut,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
