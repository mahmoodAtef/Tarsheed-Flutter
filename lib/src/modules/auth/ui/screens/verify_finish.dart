import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/large_button.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../../../core/widgets/text_field.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthBloc _authBloc = AuthBloc.instance;

  // Password validation constants
  static const int _minPasswordLength = 8;
  static const int _maxPasswordLength = 30;
  static const int _minDigitsRequired = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          const Positioned.fill(child: BackGroundRectangle()),
          SafeArea(
            child: BlocListener<AuthBloc, AuthState>(
              bloc: _authBloc,
              listener: (context, state) =>
                  _handleAuthStateChanges(context, state),
              child: _buildBody(context, theme),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is ResetPasswordSuccessState) {
      context.pushReplacement(LoginPage());
    } else if (state is AuthErrorState) {
      ExceptionManager.showMessage(state.exception);
    }
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 40.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 50.h),
              _buildPasswordField(context),
              SizedBox(height: 20.h),
              _buildConfirmPasswordField(context),
              SizedBox(height: 15.h),
              _buildFinishButton(context),
              _buildBottomSpacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainTitle(mainText: S.of(context).verifyYourIdentity),
        SizedBox(height: 5.h),
        SupTitle(text2: S.of(context).enterNewPassword),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextField(
      controller: _passwordController,
      hintText: S.of(context).password,
      isPassword: true,
      validator: (value) => _validatePassword(context, value),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return CustomTextField(
      controller: _confirmPasswordController,
      hintText: S.of(context).confirmPassword,
      isPassword: true,
      validator: (value) => _validateConfirmPassword(context, value),
    );
  }

  String? _validatePassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).passwordRequired;
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < _minPasswordLength) {
      return S.of(context).passwordMinLength;
    }

    if (trimmedValue.length > _maxPasswordLength) {
      return S.of(context).passwordMaxLength;
    }

    if (!_hasUppercase(trimmedValue)) {
      return S.of(context).passwordUppercaseRequired;
    }

    if (!_hasLowercase(trimmedValue)) {
      return S.of(context).passwordLowercaseRequired;
    }

    if (!_hasRequiredDigits(trimmedValue)) {
      return S.of(context).passwordDigitsRequired;
    }

    return null;
  }

  String? _validateConfirmPassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).confirmPasswordRequired;
    }

    if (value.trim() != _passwordController.text.trim()) {
      return S.of(context).passwordsDoNotMatch;
    }

    return null;
  }

  bool _hasUppercase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  bool _hasLowercase(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  bool _hasRequiredDigits(String password) {
    final digits = RegExp(r'\d').allMatches(password);
    return digits.length >= _minDigitsRequired;
  }

  Widget _buildFinishButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      builder: (context, state) {
        return DefaultButton(
          title: S.of(context).finish,
          isLoading: state is ResetPasswordLoadingState,
          onPressed: () => _handleFinishPressed(context),
        );
      },
    );
  }

  void _handleFinishPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        ResetPasswordEvent(_passwordController.text.trim()),
      );
    }
  }

  Widget _buildBottomSpacer() {
    return SizedBox(
        height: 200.h); // Using responsive height instead of percentage
  }
}
