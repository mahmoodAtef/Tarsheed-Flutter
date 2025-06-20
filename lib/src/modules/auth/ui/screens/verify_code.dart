import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/text_field.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_finish.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/main_screen.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/large_button.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';

class CodeVerificationScreen extends StatefulWidget {
  final String email;
  final bool? isFromForgotPassword;

  const CodeVerificationScreen(
      {Key? key, required this.email, this.isFromForgotPassword = true})
      : super(key: key);

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc.instance;
    authBloc.add(const StartResendCodeTimerEvent());
  }

  @override
  void dispose() {
    _codeController.dispose();
    authBloc.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BackGroundRectangle()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 97.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 15.h),
                  _buildCodeTextField(context),
                  SizedBox(height: 16.h),
                  _buildBlocListener(),
                  _buildVerifyButton(context),
                  SizedBox(height: 16.h),
                  _buildResendCodeSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainTitle(mainText: S.of(context).verifyYourEmail),
        SizedBox(height: 1.h),
        SupTitle(text2: S.of(context).enterVerificationCode),
      ],
    );
  }

  Widget _buildCodeTextField(BuildContext context) {
    return CustomTextField(
      controller: _codeController,
      keyboardType: TextInputType.number,
      hintText: S.of(context).verificationCode,
      validator: (value) => _validateCode(context, value),
    );
  }

  Widget _buildBlocListener() {
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is ConfirmForgotPasswordCodeSuccessState) {
          if (widget.isFromForgotPassword == true) {
            context.push(ResetPasswordScreen());
          }
        } else if (state is VerifyEmailSuccessState) {
          if (widget.isFromForgotPassword == false) {
            context.pushReplacement(MainScreen());
          }
        } else if (state is AuthErrorState) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        return DefaultButton(
          title: S.of(context).Continue,
          isLoading: _isVerificationLoading(state),
          onPressed: () => _handleVerification(),
        );
      },
    );
  }

  Widget _buildResendCodeSection(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        return Row(
          children: [
            Text(
              S.of(context).didNtReceiveCode,
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            _buildResendContent(context, state, theme),
          ],
        );
      },
    );
  }

  Widget _buildResendContent(
      BuildContext context, AuthState state, ThemeData theme) {
    if (state is ResendVerificationCodeTimerState && state.seconds > 0) {
      return Text(
        S.of(context).resendCodeIn(state.seconds),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.error,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return TextButton(
      onPressed: _handleResendCode,
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      ),
      child: Text(S.of(context).resendCode),
    );
  }

  // Helper Methods
  String? _validateCode(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterVerificationCode;
    }
    if (value.length < 6) {
      return S.of(context).codeMustBeAtLeast6Digits;
    }
    return null;
  }

  bool _isVerificationLoading(AuthState state) {
    return state is ConfirmForgotPasswordCodeLoadingState ||
        state is VerifyEmailLoadingState;
  }

  void _handleVerification() {
    if (_formKey.currentState?.validate() ?? false) {
      final code = _codeController.text.trim();
      if (widget.isFromForgotPassword == true) {
        authBloc.add(ConfirmForgotPasswordCodeEvent(code));
      } else {
        authBloc.add(VerifyEmailEvent(code));
      }
    }
  }

  void _handleResendCode() {
    authBloc.add(ResendVerificationCodeEvent());
    authBloc.add(const StartResendCodeTimerEvent());
  }
}
