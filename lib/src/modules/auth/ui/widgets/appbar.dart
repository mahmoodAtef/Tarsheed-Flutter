import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({required this.text, super.key});

  final String text;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.chevron_left, color: Colors.black, size: 24.sp),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
