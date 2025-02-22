import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_email.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../../core/utils/image_manager.dart';
import '../../data/models/email_and_password_registration_form.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/large_button.dart';
import '../widgets/social_icon.dart';
import '../widgets/main_title.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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
              if (state is RegisterSuccessState) {
                context.push("/EmailVerificationScreen");
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainTitle(maintext: S.of(context).create_account),
                      SizedBox(height: 10),
                      SupTitle(text2: S.of(context).create_account_desc),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              fieldType: FieldType.firstName,
                              controller: firstNameController,
                              hintText: S.of(context).first_name,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomTextField(
                              fieldType: FieldType.lastName,
                              controller: lastNameController,
                              hintText: S.of(context).last_name,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        fieldType: FieldType.email,
                        controller: emailController,
                        hintText: S.of(context).email,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        fieldType: FieldType.password,
                        controller: passwordController,
                        hintText: S.of(context).password,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        fieldType: FieldType.confirmPassword,
                        controller: confirmPasswordController,
                        originalPasswordController: passwordController,
                        hintText: S.of(context).confirm_password,
                      ),
                      SizedBox(height: 30),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          if (state is RegisterLoadingState) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return LargeButton(
                            textB: S.of(context).sign_up,
                            formKey: formKey,
                            emailController: emailController,
                            passwordController: passwordController,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(S.of(context).password_mismatch),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  final registrationForm =
                                      EmailAndPasswordRegistrationForm(
                                    lastName: firstNameController.text.trim(),
                                    firstName: lastNameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                                  context.read<AuthBloc>().add(
                                        RegisterWithEmailAndPasswordEvent(
                                            form: registrationForm),
                                      );
                                }
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(S.of(context).already_have_account),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Text(
                          S.of(context).or_continue_with,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2666DE),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialIcon(
                            image: AssetsManager.google,
                            scale: 1.3,
                          ),
                          SizedBox(width: 8),
                          SocialIcon(
                            image: AssetsManager.facebook,
                            scale: 2,
                          ),
                          SizedBox(width: 8),
                          SocialIcon(image: AssetsManager.apple)
                        ],
                      )
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
