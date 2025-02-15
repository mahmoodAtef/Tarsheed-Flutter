import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(text: S.of(context).account), /////////////
      body: Container(
        color: Colors.white,
        width: 391,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildItem(
              icon: Icons.person_outline,
              title: S.of(context).profile, /////////////
              subtitle: S.of(context).editPassNaAddUseEm, /////////////
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            BuildItem(
              icon: Icons.shield_outlined,
              title: S.of(context).security, /////////////
              subtitle: S.of(context).faceTwoStVerification, /////////////
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecurityPage()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            BuildItem(
              icon: Icons.settings,
              title: S.of(context).settings, /////////////
              subtitle: S.of(context).lanBackEneMO, /////////////
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingPage()));
              },
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border(
                      bottom: BorderSide(color: Color(0xFFEEEEEEEE), width: 3)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00000040),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                width: 359,
                height: 34,
                child: Row(
                  children: [
                    Text(S.of(context).rateApplication, /////////////
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(
                      width: 160,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextButton(
              onPressed: () {},
              child: Center(
                child: Text(
                  S.of(context).signOut, /////////////
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
