import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../../generated/l10n.dart';

class EditPasswordPage extends StatefulWidget {
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
          Navigator.of(context).pop(); // close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).passwordUpdatedSuccessfully)),
          );
          Navigator.pop(context); // go back
        } else if (state is AuthErrorState) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(text: S.of(context).editPassword),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.of(context).currentPassword,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.of(context).newPassword,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.of(context).confirmNewPassword,
                ),
              ),
              SizedBox(height: 32.h),
              Container(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
                        ),
                      );
                      return;
                    }

                    context.read<AuthBloc>().add(
                          UpdatePasswordEvent(
                            oldPassword: oldPassword,
                            newPassword: newPassword,
                          ),
                        );
                  },
                  child: Text(
                    S.of(context).updatePassword,
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
