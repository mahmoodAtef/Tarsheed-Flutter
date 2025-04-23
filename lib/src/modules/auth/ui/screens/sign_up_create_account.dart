import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_code.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/utils/image_manager.dart';
import '../../data/models/email_and_password_registration_form.dart';
import '../../../../core/widgets/large_button.dart';
import '../widgets/main_title.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../widgets/social_icon.dart';
import '../widgets/sup_title.dart';
import '../../../../core/widgets/text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthBloc authBloc = AuthBloc.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: BackGroundRectangle()),
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is RegisterSuccessState) {
                context.push(
                    CodeVerificationScreen(email: emailController.text.trim()));
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
                      MainTitle(mainText: S.of(context).createAccount),
                      SizedBox(height: 10.h),
                      SupTitle(text2: S.of(context).createAccountDesc),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: firstNameController,
                              hintText: S.of(context).firstName,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return S.of(context).firstNameRequired;
                                }
                                final trimmedValue = value.trim();
                                if (trimmedValue.length < 2) {
                                  return S.of(context).nameMinLength;
                                }
                                if (trimmedValue.length > 10) {
                                  return S.of(context).nameMaxLength;
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: lastNameController,
                              hintText: S.of(context).lastName,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return S.of(context).lastNameRequired;
                                }
                                final trimmedValue = value.trim();
                                if (trimmedValue.length < 2) {
                                  return S.of(context).nameMinLength;
                                }
                                if (trimmedValue.length > 10) {
                                  return S.of(context).nameMaxLength;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: S.of(context).email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return S.of(context).emailRequired;
                          }
                          final trimmedValue = value.trim();
                          if (trimmedValue.length > 30) {
                            return S.of(context).emailMaxLength;
                          }
                          if (!value.contains('@')) {
                            return S.of(context).invalidEmailFormat;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
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

                          final digits = RegExp(r'\d').allMatches(trimmedValue);
                          if (digits.isEmpty) {
                            return S.of(context).passwordDigitsRequired;
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField(
                        controller: confirmPasswordController,
                        hintText: S.of(context).confirmPassword,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return S.of(context).confirmPasswordRequired;
                          }
                          if (value.trim() != passwordController.text.trim()) {
                            return S.of(context).passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25.h),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          if (state is RegisterLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return DefaultButton(
                            title: S.of(context).signUp,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final registrationForm =
                                    EmailAndPasswordRegistrationForm(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                                context.read<AuthBloc>().add(
                                      RegisterWithEmailAndPasswordEvent(
                                          form: registrationForm),
                                    );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          onPressed: () {
                            context.push(LoginPage());
                          },
                          child: Text(S.of(context).alreadyHaveAccount),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Center(
                        child: Text(
                          S.of(context).orContinueWith,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF2666DE),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: state is LoginWithGoogleLoadingState
                                    ? null
                                    : () {
                                        context
                                            .read<AuthBloc>()
                                            .add(const LoginWithGoogleEvent());
                                      },
                                child: state is LoginWithGoogleLoadingState
                                    ? const CircularProgressIndicator()
                                    : SocialIcon(
                                        image: AssetsManager.google,
                                        scale: 1.3,
                                      ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: state is LoginWithFacebookLoadingState
                                    ? null
                                    : () {
                                        context.read<AuthBloc>().add(
                                            const LoginWithFacebookEvent());
                                      },
                                child: state is LoginWithFacebookLoadingState
                                    ? const CircularProgressIndicator()
                                    : SocialIcon(
                                        image: AssetsManager.facebook,
                                        scale: 2,
                                      ),
                              ),
                              SizedBox(width: 8.w),
                              SocialIcon(image: AssetsManager.apple),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
