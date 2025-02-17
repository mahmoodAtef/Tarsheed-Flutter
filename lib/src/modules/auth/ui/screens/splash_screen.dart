import 'package:flutter/material.dart';
import 'package:tarsheed/home_page.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // مدة ظهور الشاشة
    bool isFirstTime = (CacheHelper.getData(key: "first_time") ?? true) as bool;

    print('isFirstTime: $isFirstTime');

    if (isFirstTime) {
      CacheHelper.saveData(key: "first_time", value: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/E-logo 1.png",
              width: 150,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
