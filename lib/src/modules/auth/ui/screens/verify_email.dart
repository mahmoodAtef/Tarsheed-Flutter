import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_code.dart';
import '../../../../../generated/l10n.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/large_button.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            SizedBox(height: 5),
                            SupTitle(
                                text2:
                                    S.of(context).enter_email_to_receive_code),
                            SizedBox(height: 50),
                            CustomTextField(
                              fieldType: FieldType.email,
                              controller: emailController,
                              hintText: S.of(context).email,
                            ),
                            SizedBox(height: 15),
                            LargeButton(
                              textB: S.of(context).continue_text,
                              formKey: formKey,
                              emailController: emailController,
                              passwordController: passwordController,
                              onpressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CodeVerificationScreen()));
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                            Container(height: 420),
                          ]))))
        ]));
  }
}
