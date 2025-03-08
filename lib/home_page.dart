import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/account_screan.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/profile_screen.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/rectangle_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Positioned.fill(
            child: BackGroundRectangle(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.5),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Image.asset(
                    AssetsManager.logo,
                    width: 500,
                    height: 500,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 2),
                  Container(
                    width: 343,
                    height: 106,
                    child: const Text(
                      "Take Control of\nYour Energy Usage",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2666DE),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 60,
                        child: ElevatedButton(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2666DE),
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            context.push("/LoginPage");
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          context.push("/SignUpScreen");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          // 🔹 نفس الـ Padding
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black, // 🔹 اللون الأساسي
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ])),
          )
        ]));
  }
}
