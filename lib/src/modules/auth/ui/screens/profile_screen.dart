import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tarsheed/generated/l10n.dart'; // استيراد ملف الترجمة
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      appBar: CustomAppBar(text: S.of(context).profile),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : AssetImage(AssetsManager.avatar) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 5.h,
                      right: 5.w,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.camera_alt,
                              size: 20.sp, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              buildTextField(S.of(context).first_name, '', false),
              buildTextField(S.of(context).last_name, '', false),
              buildTextField(S.of(context).email, '', false),
              buildTextField(S.of(context).password, '', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value, bool isPassword) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
          SizedBox(height: 5.h),
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2666DE)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.blue, width: 1.5.w),
              ),
              suffixIcon: isPassword
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.visibility_off, size: 18.sp),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, size: 18.sp),
                          onPressed: () {},
                        ),
                      ],
                    )
                  : Icon(Icons.edit, size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
