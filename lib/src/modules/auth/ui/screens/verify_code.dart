import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_finish.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class CodeVerificationScreen extends StatelessWidget {
  CodeVerificationScreen({super.key});
  final TextEditingController codeController=TextEditingController();
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
                            MainTitle(maintext: "Verify Your Identity "),
                            SizedBox(height: 1),
                            SupTitle(
                                text2: "We have sent an email to mo****@gmail."),
                            SizedBox(height: 50),
                            CustomTextField(
                              fieldType: FieldType.code,
                              controller: codeController,
                              hintText: "Enter Code",
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
                                            builder: (context) => ResetPasswordScreen()));
                                  },
                                  child: Text("Continue",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      )),
                                )),
                            Container(
                              height: 420,
                            )
                          ]
                      )
                  )
              )
          )
        ]));
  }
}
