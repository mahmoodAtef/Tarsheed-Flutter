import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';

import '../../../core/services/dep_injection.dart';
import '../data/models/security_settings.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// singleton instance
  static AuthBloc? _authBloc;

  static AuthBloc get instance {
    return _authBloc ??= AuthBloc();
  }

  final AuthRepository authRepository = sl();

  AuthBloc() : super(AuthInitial()) {
    on<StartResendCodeTimerEvent>((event, emit) {
      _startResendTimer(emit);
    });

    /*
     */
    on<AuthEvent>((event, emit) async {
      if (event is RegisterWithEmailAndPasswordEvent) {
        await _handleRegisterWithEmailAndPasswordEvent(event, emit);
      } else if (event is VerifyEmailEvent) {
        await _handleVerifyEmailEvent(event, emit);
      } else if (event is LoginWithEmailAndPasswordEvent) {
        await _handleLoginWithEmailAndPasswordEvent(event, emit);
      } else if (event is ResendVerificationCodeEvent) {
        await _handleResendVerificationCodeEvent(event, emit);
      } else if (event is ForgotPasswordEvent) {
        await _handleForgotPasswordEvent(event, emit);
      } else if (event is ConfirmForgotPasswordCode) {
        await _handleConfirmForgotPasswordCode(event, emit);
      } else if (event is ResetPasswordEvent) {
        await _handleResetPasswordEvent(event, emit);
      } else if (event is UpdatePasswordEvent) {
        await _handleUpdatePasswordEvent(event, emit);
      } else if (event is LogoutEvent) {
        await _handleLogoutEvent(event, emit);
      } else if (event is LoginWithGoogleEvent) {
        await _handleLoginWithGoogleEvent(event, emit);
      } else if (event is LoginWithFacebookEvent) {
        await _handleLoginWithFacebookEvent(event, emit);
      }
    });
  }

  Future<void> _handleRegisterWithEmailAndPasswordEvent(
      RegisterWithEmailAndPasswordEvent event, Emitter<AuthState> emit) async {
    emit(RegisterLoadingState());
    final result = await authRepository.registerWithEmailAndPassword(
        registrationForm: event.form);
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(RegisterSuccessState());
    });
  }

  Future<void> _handleLoginWithEmailAndPasswordEvent(
      LoginWithEmailAndPasswordEvent event, Emitter<AuthState> emit) async {
    emit(LoginWithEmailAndPasswordLoadingState());

    final result = await authRepository.loginWithEmailAndPassword(
        email: event.email, password: event.password);
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(LoginSuccessState());
    });
  }

  Future<void> _handleVerifyEmailEvent(
      VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(VerifyEmailLoadingState());

    final result = await authRepository.verifyEmail(
      code: event.code,
    );

    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(VerifyEmailSuccessState());
    });
  }

  Future<void> _handleResendVerificationCodeEvent(
      ResendVerificationCodeEvent event, Emitter<AuthState> emit) async {
    emit(VerifyEmailLoadingState());

    final result = await authRepository.resendEmailVerificationCode();
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(ResendVerificationCodeSuccessState());
    });
  }

  Future<void> _handleForgotPasswordEvent(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ForgotPasswordLoadingState());
    final result = await authRepository.forgetPassword(email: event.email);
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(ForgotPasswordSuccessState());
    });
  }

  Future<void> _handleConfirmForgotPasswordCode(
      ConfirmForgotPasswordCode event, Emitter<AuthState> emit) async {
    emit(ConfirmForgotPasswordCodeLoadingState());

    final result = await authRepository.confirmForgotPasswordCode(
      code: event.code,
    );
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(ConfirmForgotPasswordCodeSuccessState());
    });
  }

  Future<void> _handleResetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ResetPasswordLoadingState());

    final result = await authRepository.resetPassword(event.newPassword);
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(ResetPasswordSuccessState());
    });
  }

  Future<void> _handleUpdatePasswordEvent(
      UpdatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(UpdatePasswordLoadingState());

    final result = await authRepository.updatePassword(
        newPassword: event.newPassword, oldPassword: event.oldPassword);
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(UpdatePasswordSuccessState());
    });
  }

  Future<void> _handleLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LogoutLoadingState());

    final result = await authRepository.logout();
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(LogoutSuccessState());
    });
  }

  Future<void> _handleLoginWithGoogleEvent(
      LoginWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(LoginWithGoogleLoadingState());

    final result = await authRepository.loginWithGoogle();
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(LoginSuccessState());
    });
  }

  Future<void> _handleLoginWithFacebookEvent(
      LoginWithFacebookEvent event, Emitter<AuthState> emit) async {
    emit(LoginWithFacebookLoadingState());

    final result = await authRepository.loginWithFacebook();
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(LoginSuccessState());
    });
  }

  // timer logic
  Timer? _resendCodeTimer;
  int? _remainingSeconds;

  void _startResendTimer(Emitter<AuthState> emit) {
    const oneSec = Duration(seconds: 1);
    _remainingSeconds = 60;
    _resendCodeTimer = Timer.periodic(oneSec, (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        _remainingSeconds = _remainingSeconds! - 1;
        emit(ResendVerificationCodeTimerState(seconds: _remainingSeconds!));
      }
    });
  }

  void cancelTimer() {
    _resendCodeTimer?.cancel();
  }
}
