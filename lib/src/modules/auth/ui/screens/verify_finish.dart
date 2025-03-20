import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/large_button.dart';
import '../widgets/main_title.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  AuthBloc authBloc = AuthBloc.instance;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(child: BackGroundRectangle()),
          SafeArea(
            child: BlocListener<AuthBloc, AuthState>(
              bloc: authBloc,
              listener: (context, state) {
                if (state is ResetPasswordSuccessState ||
                    state is UpdatePasswordSuccessState) {
                  context.pop();
                } else if (state is AuthErrorState) {
                  ExceptionManager.showMessage(state.exception);
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTitle(mainText: S.of(context).verifyYourIdentity),
                        SizedBox(height: 5.h),
                        SupTitle(text2: S.of(context).enterNewPassword),
                        SizedBox(height: 50.h),
                        CustomTextField(
                          controller: passwordController,
                          hintText: S.of(context).password,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return S.of(context).passwordRequired;
                            }

                            final trimmedValue = value.trim();
                            if (trimmedValue.length < 8) {
                              return S.of(context).passwordMinLength;
                            }
                            if (trimmedValue.length > 30) {
                              return S.of(context).passwordMaxLength;
                            }

                            if (!RegExp(r'[A-Z]').hasMatch(trimmedValue)) {
                              return S.of(context).passwordUppercaseRequired;
                            }

                            if (!RegExp(r'[a-z]').hasMatch(trimmedValue)) {
                              return S.of(context).passwordLowercaseRequired;
                            }

                            final digits =
                                RegExp(r'\d').allMatches(trimmedValue);
                            if (digits.length < 6) {
                              return S.of(context).passwordDigitsRequired;
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          controller: confirmPasswordController,
                          hintText: S.of(context).confirmPassword,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return S.of(context).confirmPasswordRequired;
                            }
                            if (value.trim() !=
                                passwordController.text.trim()) {
                              return S.of(context).passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.h),
                        BlocBuilder<AuthBloc, AuthState>(
                          bloc: authBloc,
                          builder: (context, state) {
                            if (state is ResetPasswordLoadingState ||
                                state is UpdatePasswordLoadingState) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return DefaultButton(
                              title: S.of(context).finish,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  authBloc.add(ResetPasswordEvent(
                                      passwordController.text.trim()));
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.2),
                      ],
                    ),
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
