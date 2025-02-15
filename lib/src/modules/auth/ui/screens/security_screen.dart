import 'package:flutter/material.dart';
import 'package:tarsheed/generated/l10n.dart'; // استيراد ملف الترجمة
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/container_with_switch.dart';
import '../widgets/large_button.dart';

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      backgroundColor: Colors.white,
      appBar: CustomAppBar(text: S.of(context).security), // استخدام الترجمة
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            CustomContainer(
              text: S.of(context).face_id, // استخدام الترجمة
              size: 18,
              height: 66,
              status: false,
            ),
            CustomContainer(
              text: S.of(context).two_step_verification, // استخدام الترجمة
              size: 18,
              height: 66,
              status: true,
            ),
            SizedBox(height: 40),
            LargeButton(
              textB: S.of(context).save, // استخدام الترجمة
              formKey: formKey,
              width: 329,
            )
          ],
        ),
      ),
    );
  }
}
