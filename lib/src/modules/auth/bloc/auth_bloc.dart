import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';
import 'package:tarsheed/src/modules/auth/data/repositories/auth_repository.dart';

import '../../../core/services/dep_injection.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository = sl();
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      if (event is RegisterWithEmailAndPasswordEvent) {
        _handleRegisterWithEmailAndPasswordEvent(event, emit);
      }
      if (event is LoginWithEmailAndPasswordEvent) {
        _handleLoginWithEmailAndPasswordEvent(event, emit);
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
    emit(LoginLoadingState());

    final result = await authRepository.loginWithEmailAndPassword(
        email: event.email, password: event.password);
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(LoginSuccessState());
    });
  }
}
