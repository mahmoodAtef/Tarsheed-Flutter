import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../auth/bloc/auth_bloc.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdatePasswordLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is UpdatePasswordSuccessState) {
          context.pop(); // close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).passwordUpdatedSuccessfully),
              backgroundColor: ColorManager.primary,
            ),
          );
          Navigator.pop(context); // go back
        } else if (state is AuthErrorState) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(text: S.of(context).editPassword),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            children: [
              _buildPasswordField(
                controller: oldPasswordController,
                label: S.of(context).currentPassword,
              ),
              SizedBox(height: 16.h),
              _buildPasswordField(
                controller: newPasswordController,
                label: S.of(context).newPassword,
              ),
              SizedBox(height: 16.h),
              _buildPasswordField(
                controller: confirmPasswordController,
                label: S.of(context).confirmNewPassword,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                    final oldPassword = oldPasswordController.text.trim();
                    final newPassword = newPasswordController.text.trim();
                    final confirmPassword =
                        confirmPasswordController.text.trim();

                    if (newPassword != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).passwordsDoNotMatch),
                          backgroundColor: ColorManager.red,
                        ),
                      );
                      return;
                    }

                    AuthBloc.instance.add(
                      UpdatePasswordEvent(
                        oldPassword: oldPassword,
                        newPassword: newPassword,
                      ),
                    );
                  },
                  child: Text(
                    S.of(context).updatePassword,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: ColorManager.darkGrey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.grey),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.primary, width: 1.5.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
