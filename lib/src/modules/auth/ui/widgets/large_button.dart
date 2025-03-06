import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LargeButton extends StatelessWidget {
  const LargeButton({
    required this.textB,
    this.icon,
    this.width,
    required this.formKey,
    this.firstNameController,
    this.lastNameController,
    this.emailController,
    this.passwordController,
    this.onPressed,
  });

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 55.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2666DE),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textB,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: 10.w),
              Icon(icon, size: 22.sp, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
