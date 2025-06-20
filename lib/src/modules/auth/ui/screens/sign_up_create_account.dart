import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/main_screen.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/utils/image_manager.dart';
import '../../../../core/widgets/large_button.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../../../core/widgets/text_field.dart';
import '../../data/models/email_and_password_registration_form.dart';
import '../widgets/main_title.dart';
import '../widgets/social_icon.dart';
import '../widgets/sup_title.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: BackGroundRectangle()),
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is RegisterSuccessState) {
                context.pushReplacement(MainScreen());
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
                      _buildNameFields(context),
                      SizedBox(height: 10.h),
                      _buildEmailField(context),
                      SizedBox(height: 10.h),
                      _buildPasswordField(context),
                      SizedBox(height: 10.h),
                      _buildConfirmPasswordField(context),
                      SizedBox(height: 25.h),
                      _buildSignUpButton(context),
                      SizedBox(height: 10.h),
                      _buildAlreadyHaveAccountButton(context, theme),
                      SizedBox(height: 25.h),
                      _buildOrContinueWithText(context, theme),
                      SizedBox(height: 10.h),
                      _buildSocialButtons(context),
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

  Widget _buildNameFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: firstNameController,
            hintText: S.of(context).firstName,
            keyboardType: TextInputType.name,
            validator: (value) => _validateFirstName(context, value),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: CustomTextField(
            controller: lastNameController,
            hintText: S.of(context).lastName,
            keyboardType: TextInputType.name,
            validator: (value) => _validateLastName(context, value),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextField(
      controller: emailController,
      hintText: S.of(context).email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => _validateEmail(context, value),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextField(
      controller: passwordController,
      hintText: S.of(context).password,
      isPassword: true,
      maxLines: 1,
      validator: (value) => _validatePassword(context, value),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return CustomTextField(
      controller: confirmPasswordController,
      hintText: S.of(context).confirmPassword,
      isPassword: true,
      maxLines: 1,
      validator: (value) => _validateConfirmPassword(context, value),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        if (state is RegisterLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }
        return DefaultButton(
          title: S.of(context).signUp,
          onPressed: () => _handleSignUp(context),
        );
      },
    );
  }

  Widget _buildAlreadyHaveAccountButton(BuildContext context, ThemeData theme) {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.onBackground,
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: () => context.push(LoginPage()),
        child: Text(S.of(context).alreadyHaveAccount),
      ),
    );
  }

  Widget _buildOrContinueWithText(BuildContext context, ThemeData theme) {
    return Center(
      child: Text(
        S.of(context).orContinueWith,
        style: theme.textTheme.labelLarge?.copyWith(
          fontSize: 14.sp,
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              context: context,
              isLoading: state is LoginWithGoogleLoadingState,
              onTap: () =>
                  context.read<AuthBloc>().add(const LoginWithGoogleEvent()),
              image: AssetsManager.google,
              scale: 1.3,
            ),
            SizedBox(width: 8.w),
            _buildSocialButton(
              context: context,
              isLoading: state is LoginWithFacebookLoadingState,
              onTap: () =>
                  context.read<AuthBloc>().add(const LoginWithFacebookEvent()),
              image: AssetsManager.facebook,
              scale: 2,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required bool isLoading,
    required VoidCallback onTap,
    required String image,
    required double scale,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: isLoading
          ? SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 2.w,
              ),
            )
          : SocialIcon(
              image: image,
              scale: scale,
            ),
    );
  }

  // Validation Methods
  String? _validateFirstName(BuildContext context, String? value) {
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
  }

  String? _validateLastName(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).lastNameRequired;
    }
    final trimmedValue = value.trim();
    if (trimmedValue.length < 2) {
      return S.of(context).nameMinLength;
    }
    if (trimmedValue.length > 20) {
      return S.of(context).nameMaxLength;
    }
    return null;
  }

  String? _validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).emailRequired;
    }
    final trimmedValue = value.trim();
    if (trimmedValue.length > 50) {
      return S.of(context).emailMaxLength;
    }
    if (!value.contains('@')) {
      return S.of(context).invalidEmailFormat;
    }
    return null;
  }

  String? _validatePassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).passwordRequired;
    }

    final trimmedValue = value.trim();
    if (trimmedValue.length < 8) {
      return S.of(context).passwordMinLength;
    }
    if (trimmedValue.length > 50) {
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
  }

  String? _validateConfirmPassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).confirmPasswordRequired;
    }
    if (value.trim() != passwordController.text.trim()) {
      return S.of(context).passwordsDoNotMatch;
    }
    return null;
  }

  void _handleSignUp(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final registrationForm = EmailAndPasswordRegistrationForm(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      context.read<AuthBloc>().add(
            RegisterWithEmailAndPasswordEvent(form: registrationForm),
          );
    }
  }
}
