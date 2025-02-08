import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/large_button.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
            children: [
              Positioned.fill(
                child: BackGroundRectangle(),
              ),SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 97),
                      child: Form(
                          key: formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MainTitle(maintext: "Verify Your Identity "),
                                SizedBox(height: 1),
                                SupTitle(text2:"Enter Your New Password" ),
                                SizedBox(height: 50),
                                SizedBox(height: 15),
                                CustomTextField(
                                  fieldType: FieldType.password,
                                  controller: passwordController,
                                  hintText: "New Password",
                                ),
                                SizedBox(height: 20),
                                CustomTextField(
                                  fieldType: FieldType.confirmPassword,
                                  controller: confirmPasswordController,
                                  originalPasswordController: passwordController,
                                  hintText: "Confirm New Password",
                                ),
                                SizedBox(height: 15,),
                                LargeButton(textB: "finish", formKey: formKey, passwordController: passwordController,
                                    onpressed: () {
                                      if (formKey.currentState!.validate()) {
                                        if (passwordController.text != confirmPasswordController.text) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Passwords do not match"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } else {print("لسه التقيل جي");}
                                      }
                                    }
                                ),
                                Container(height: 400,)
                              ]
                          )
                      )
                  )

              )
            ]
        )
    );
  }
}
