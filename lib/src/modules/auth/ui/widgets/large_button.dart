import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LargeButton extends StatelessWidget {
  const LargeButton(
      {required this.textB,
      this.icon,
      this.width,
      required this.formKey,
      this.firstNameController,
      this.lastNameController,
      this.emailController,
      this.passwordController,
      this.onPressed});

  final String textB;
  final IconData? icon;
  final double? width;
  final GlobalKey<FormState> formKey;
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final VoidCallback? onPressed;

  void validateForm() {
    if (formKey.currentState!.validate()) {
      print("first name: ${firstNameController?.text}");
      print("last name: ${lastNameController?.text}");
      print("Email: ${emailController?.text}");
      print("Password: ${passwordController?.text}");
      // هنا تقدر تضيف كود تسجيل الدخول
    }
  }

  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 357,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2666DE),
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(textB,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                )),
            if (icon != null)
              Icon(
                icon,
                color: Colors.white,
              ),
            if (icon != null)
              SizedBox(
                width: 8,
              ),
          ],
        ),
      ),
    );
  }
}
