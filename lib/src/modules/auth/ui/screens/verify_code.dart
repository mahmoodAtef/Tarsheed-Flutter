import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_finish.dart';
import '../../../../../generated/l10n.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class CodeVerificationScreen extends StatelessWidget {
  CodeVerificationScreen({super.key});

  final TextEditingController codeController = TextEditingController();

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
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        MainTitle(maintext: S.of(context).verify_your_identity),
                        SizedBox(height: 1),
                        SupTitle(text2: S.of(context).sent_email_message),
                        SizedBox(height: 50),
                        CustomTextField(
                          fieldType: FieldType.code,
                          controller: codeController,
                          hintText: S.of(context).enter_code,
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                            width: 357,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2666DE),
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPasswordScreen()));
                              },
                              child: Text(S.of(context).continue_text,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  )),
                            )),
                        Container(
                          height: 420,
                        )
                      ]))))
        ]));
  }
}
