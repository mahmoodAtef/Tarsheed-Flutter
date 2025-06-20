import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_code.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/large_button.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../../../core/widgets/text_field.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({
    super.key,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final AuthBloc _authBloc = AuthBloc.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          const Positioned.fill(child: BackGroundRectangle()),
          BlocListener<AuthBloc, AuthState>(
            bloc: _authBloc,
            listener: (context, state) =>
                _handleAuthStateChanges(context, state),
            child: _buildBody(context, theme),
          ),
        ],
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is ResendVerificationCodeSuccessState) {
      context.push(
        CodeVerificationScreen(email: _emailController.text.trim()),
      );
    } else if (state is ForgotPasswordSuccessState) {
      context.push(
        CodeVerificationScreen(email: _emailController.text.trim()),
      );
    } else if (state is AuthErrorState) {
      ExceptionManager.showMessage(state.exception);
    }
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 97.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 50.h),
              _buildEmailField(context),
              SizedBox(height: 15.h),
              _buildContinueButton(context),
              SizedBox(height: 15.h),
              _buildSpacer(),
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
        SupTitle(text2: S.of(context).enterEmailToReceiveCode),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextField(
      controller: _emailController,
      hintText: S.of(context).email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => _validateEmail(context, value),
    );
  }

  String? _validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.of(context).emailRequired;
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 30) {
      return S.of(context).emailMaxLength;
    }

    if (!_isValidEmailFormat(trimmedValue)) {
      return S.of(context).invalidEmailFormat;
    }

    return null;
  }

  bool _isValidEmailFormat(String email) {
    return email.contains('@') &&
        email.contains('.') &&
        email.indexOf('@') < email.lastIndexOf('.');
  }

  Widget _buildContinueButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      builder: (context, state) {
        if (_isLoadingState(state)) {
          return _buildLoadingIndicator(context);
        }

        return DefaultButton(
          title: S.of(context).continueText,
          onPressed: () => _handleContinuePressed(context),
        );
      },
    );
  }

  bool _isLoadingState(AuthState state) {
    return state is VerifyEmailLoadingState ||
        state is ForgotPasswordLoadingState;
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: CircularProgressIndicator(
        color: theme.colorScheme.primary,
        strokeWidth: 3.0,
      ),
    );
  }

  void _handleContinuePressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            ForgotPasswordEvent(_emailController.text.trim()),
          );
    }
  }

  Widget _buildSpacer() {
    return SizedBox(height: 420.h);
  }
}
