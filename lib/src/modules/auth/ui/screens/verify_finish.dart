import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/exception_manager.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/large_button.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';
import '../../../../../generated/l10n.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
              if (state is ResetPasswordSuccessState) {
                Navigator.pop(context);
              } else if (state is AuthErrorState) {
                ExceptionManager.showMessage(state.exception);
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 97),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainTitle(maintext: S.of(context).verify_your_identity),
                      SizedBox(height: 5),
                      SupTitle(text2: S.of(context).enter_new_password),
                      SizedBox(height: 50),
                      CustomTextField(
                        fieldType: FieldType.password,
                        controller: passwordController,
                        hintText: S.of(context).new_password,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        fieldType: FieldType.confirmPassword,
                        controller: confirmPasswordController,
                        originalPasswordController: passwordController,
                        hintText: S.of(context).confirm_new_password,
                      ),
                      SizedBox(height: 15),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          if (state is ResetPasswordLoadingState) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return LargeButton(
                            textB: S.of(context).finish,
                            formKey: formKey,
                            passwordController: passwordController,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                authBloc.add(
                                  ResetPasswordEvent(
                                      passwordController.text.trim()),
                                );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 420),
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
