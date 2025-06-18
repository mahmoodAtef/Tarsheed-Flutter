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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final AuthBloc authBloc = AuthBloc.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: BackGroundRectangle()),
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is ResendVerificationCodeSuccessState) {
                context.push(
                    CodeVerificationScreen(email: emailController.text.trim()));
              }
              if (state is ForgotPasswordSuccessState) {
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
                      MainTitle(mainText: S.of(context).verifyYourIdentity),
                      SizedBox(height: 5.h),
                      SupTitle(text2: S.of(context).enterEmailToReceiveCode),
                      SizedBox(height: 50.h),
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
                      SizedBox(height: 15.h),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          if (state is VerifyEmailLoadingState ||
                              state is ForgotPasswordLoadingState) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return DefaultButton(
                            title: S.of(context).continueText,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                    ForgotPasswordEvent(
                                        emailController.text.trim()));
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 15.h),
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
