import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart';
import '../widgets/large_button.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Positioned.fill(
            child: BackGroundRectangle(),
          ),
          SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 97),
                  child: Form(
                      key: formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainTitle(
                                maintext: S.of(context).verify_your_identity),
                            SizedBox(height: 1),
                            SupTitle(text2: S.of(context).enter_new_password),
                            SizedBox(height: 50),
                            SizedBox(height: 15),
                            CustomTextField(
                              fieldType: FieldType.password,
                              controller: passwordController,
                              hintText: S.of(context).new_password,
                            ),
                            SizedBox(height: 20),
                            CustomTextField(
                              fieldType: FieldType.confirmPassword,
                              controller: confirmPasswordController,
                              originalPasswordController: passwordController,
                              hintText: S.of(context).confirm_new_password,
                            ),
                            SizedBox(height: 15),
                            LargeButton(
                                textB: S.of(context).finish,
                                formKey: formKey,
                                passwordController: passwordController,
                                onpressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (passwordController.text !=
                                        confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(S
                                              .of(context)
                                              .passwords_do_not_match),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      print("لسه التقيل جي");
                                    }
                                  }
                                }),
                            Container(height: 400),
                          ]))))
        ]));
  }
}
