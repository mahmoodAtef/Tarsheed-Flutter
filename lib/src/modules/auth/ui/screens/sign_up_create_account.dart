import 'package:flutter/material.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_email.dart';

import '../../../../core/utils/image_manager.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/large_button.dart';
import '../widgets/social_icon.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: BackGroundRectangle()),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 97),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainTitle(maintext: S.of(context).create_account),
                    SizedBox(height: 10),
                    SupTitle(text2: S.of(context).create_account_desc),
                    SizedBox(height: 50),
                    CustomTextField(
                      fieldType: FieldType.email,
                      controller: emailController,
                      hintText: S.of(context).email,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      fieldType: FieldType.password,
                      controller: passwordController,
                      hintText: S.of(context).password,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      fieldType: FieldType.confirmPassword,
                      controller: confirmPasswordController,
                      originalPasswordController: passwordController,
                      hintText: S.of(context).confirm_password,
                    ),
                    SizedBox(height: 35),
                    LargeButton(
                      textB: S.of(context).sign_up,
                      formKey: formKey,
                      emailController: emailController,
                      passwordController: passwordController,
                      onpressed: () {
                        if (formKey.currentState!.validate()) {
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).password_mismatch),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EmailVerificationScreen()),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(S.of(context).already_have_account),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        S.of(context).or_continue_with,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2666DE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialIcon(
                          image: AssetsManager.google,
                          scale: 1.3,
                        ),
                        SizedBox(width: 8),
                        SocialIcon(
                          image: AssetsManager.facebook,
                          scale: 2,
                        ),
                        SizedBox(width: 8),
                        SocialIcon(image: AssetsManager.apple)
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
