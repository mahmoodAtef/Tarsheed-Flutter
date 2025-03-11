import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_finish.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/main_title.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class CodeVerificationScreen extends StatelessWidget {
  CodeVerificationScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: BackGroundRectangle()),
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is VerifyEmailSuccessState) {
                context.push(ResetPasswordScreen());
              } else if (state is ConfirmForgotPasswordCodeSuccessState) {
                context.push(ResetPasswordScreen());
              } else if (state is AuthErrorState) {
                ExceptionManager.showMessage(state.exception);
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 97.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainTitle(maintext: S.of(context).verify_your_identity),
                      SizedBox(height: 1.h),
                      SupTitle(text2: "We have sent an email to mo****@gmail"),
                      SizedBox(height: 50.h),
                      CustomTextField(
                        fieldType: FieldType.code,
                        controller: codeController,
                        hintText: S.of(context).enter_code,
                      ),
                      SizedBox(height: 15.h),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          if (state is VerifyEmailLoadingState) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return SizedBox(
                            width: double.infinity,
                            height: 60.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2666DE),
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        ConfirmForgotPasswordCode(
                                          codeController.text.trim(),
                                        ),
                                      );
                                }
                              },
                              child: Text(
                                S.of(context).continue_text,
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Row(
                          children: [
                            Text(
                              S.of(context).didnot_receive,
                              style: TextStyle(
                                color: Color(0xFF494949),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(ResendVerificationCodeEvent());
                              },
                              child: Text(
                                S.of(context).resend_code,
                                style: TextStyle(
                                  color: Color(0xFF1877F2),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 420.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
