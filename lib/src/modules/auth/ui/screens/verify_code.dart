import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';

class CodeVerificationScreen extends StatefulWidget {
  final String email;

  const CodeVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(StartResendCodeTimerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Your Email")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter the verification code sent to your email"),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Verification Code"),
            ),
            const SizedBox(height: 16),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is VerifyEmailSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Email verified successfully!")),
                  );
                  Navigator.pop(context);
                } else if (state is AuthErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.exception.toString())),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final code = _codeController.text.trim();
                        if (code.isNotEmpty) {
                          context.read<AuthBloc>().add(VerifyEmailEvent(code));
                        }
                      },
                      child: state is VerifyEmailLoadingState
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Verify"),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is ResendVerificationCodeTimerState) {
                          return Text("Resend code in: ${state.seconds}s",
                              style: const TextStyle(color: Colors.red));
                        }
                        return TextButton(
                          onPressed:
                              state is ResendVerificationCodeTimerState &&
                                      state.seconds > 0
                                  ? null
                                  : () {
                                      context
                                          .read<AuthBloc>()
                                          .add(ResendVerificationCodeEvent());
                                      context
                                          .read<AuthBloc>()
                                          .add(StartResendCodeTimerEvent());
                                    },
                          child: const Text("Resend Code"),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
