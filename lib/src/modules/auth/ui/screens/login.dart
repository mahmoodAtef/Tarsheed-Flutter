import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/welcome_screen.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/sign_up_create_account.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_email.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/home_screen.dart';

import '../../../../core/utils/image_manager.dart';
import '../../../../core/widgets/large_button.dart';
import '../widgets/main_title.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../widgets/social_icon.dart';
import '../widgets/sup_title.dart';
import '../../../../core/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthBloc authBloc = AuthBloc.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: BackGroundRectangle(),
          ),
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is LoginSuccessState) {
                context.pushReplacement(HomeScreen());
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
                      MainTitle(mainText: S.of(context).loginHere),
                      SizedBox(height: 20.h),
                      SupTitle(
                        text2: S.of(context).welcomeBack,
                        fontWeight: FontWeight.w600,
                        size: 20.sp,
                        width: 228.w,
                      ),
                      SizedBox(height: 50.h),
                      CustomTextField(
                        controller: emailController,
                        hintText: S.of(context).email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '${S.of(context).email} ${S.of(context).isRequired}';
                          }
                          final trimmedValue = value.trim();
                          if (trimmedValue.length > 40) {
                            return '${S.of(context).email} ${S.of(context).cannotExceed} 40 ${S.of(context).characters}';
                          }
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            caseSensitive: false,
                          );
                          if (!emailRegex.hasMatch(trimmedValue)) {
                            return S.of(context).invalidEmail;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: passwordController,
                        hintText: S.of(context).password,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '${S.of(context).password} ${S.of(context).isRequired}';
                          }
                          final trimmedValue = value.trim();
                          if (trimmedValue.length < 6) {
                            return '${S.of(context).password} ${S.of(context).mustBeAtLeast} 6 ${S.of(context).characters}';
                          }
                          if (trimmedValue.length > 25) {
                            return '${S.of(context).password} ${S.of(context).cannotExceed} 25 ${S.of(context).characters}';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 21.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            context.push(EmailVerificationScreen());
                          },
                          child: Text(
                            S.of(context).forgotPassword,
                            style: TextStyle(
                                color: ColorManager.primary,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          return DefaultButton(
                            isLoading:
                                state is LoginWithEmailAndPasswordLoadingState,
                            title: S.of(context).signIn,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      LoginWithEmailAndPasswordEvent(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      ),
                                    );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 15.h),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onPressed: () {
                            context.push(SignUpScreen());
                          },
                          child: Text(S.of(context).createNewAccount),
                        ),
                      ),
                      SizedBox(height: 30.h),
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
          ),
        ],
      ),
    );
  }
}
