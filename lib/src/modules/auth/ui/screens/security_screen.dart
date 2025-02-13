import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(text: "Security"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            CustomContainer(
              text: "Face ID",
              size: 18,
              height: 66,
              status: false,
            ),
            CustomContainer(
              text: "TWO-Step Verfication",
              size: 18,
              height: 66,
              status: true,
            ),
            SizedBox(height: 40),
            LargeButton(
              textB: "Save",
              formKey: formKey,
              width: 329,
            )
          ],
        ),
      ),
    );
  }
}
