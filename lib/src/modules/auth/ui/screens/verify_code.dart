import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_finish.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/text_field.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/large_button.dart';
import '../widgets/main_title.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/sup_title.dart';

class CodeVerificationScreen extends StatefulWidget {
  final String email;

  const CodeVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthBloc authBloc = AuthBloc.instance;

  @override
  void initState() {
    super.initState();
    authBloc.add(const StartResendCodeTimerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const Positioned.fill(child: BackGroundRectangle()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 97.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainTitle(mainText: S.of(context).verifyYourEmail),
                SizedBox(height: 1.h),
                SupTitle(text2: S.of(context).enterVerificationCode),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  hintText: S.of(context).verificationCode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).pleaseEnterVerificationCode;
                    }
                    if (value.length < 6) {
                      return S.of(context).codeMustBeAtLeast6Digits;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // BlocListener لمراقبة نجاح تأكيد الكود
                BlocListener<AuthBloc, AuthState>(
                  bloc: authBloc,
                  listener: (context, state) {
                    if (state is ConfirmForgotPasswordCodeSuccessState) {
                      // الانتقال إلى صفحة إعادة تعيين كلمة المرور
                      context.push(ResetPasswordScreen());
                    } else if (state is AuthErrorState) {
                      ExceptionManager.showMessage(state.exception);
                    }
                  },
                  child: Container(),
                ),

                BlocBuilder<AuthBloc, AuthState>(
                  bloc: authBloc,
                  builder: (context, state) {
                    return DefaultButton(
                      title: S.of(context).Continue,
                      isLoading: state is ConfirmForgotPasswordCodeLoadingState,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final code = _codeController.text.trim();
                          authBloc.add(ConfirmForgotPasswordCodeEvent(code));
                        }
                      },
                    );
                  },
                ),

                SizedBox(height: 16.h),
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: authBloc,
                  builder: (context, state) {
                    return Row(
                      children: [
                        Text(
                          S.of(context).didNtReceiveCode,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        if (state is ResendVerificationCodeTimerState)
                          Text(
                            S.of(context).resendCodeIn(state.seconds),
                            style: TextStyle(color: ColorManager.red),
                          ),
                        if (state is! ResendVerificationCodeTimerState ||
                            (state is ResendVerificationCodeTimerState &&
                                state.seconds == 0))
                          TextButton(
                            onPressed: () {
                              authBloc.add(ForgotPasswordEvent(widget.email));
                              authBloc.add(const StartResendCodeTimerEvent());
                            },
                            child: Text(
                              S.of(context).resendCode,
                              style: TextStyle(color: ColorManager.primary),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    authBloc.cancelTimer();
    super.dispose();
  }
}
