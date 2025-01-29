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
    });
  }

  Future<void> _handleRegisterWithEmailAndPasswordEvent(
      RegisterWithEmailAndPasswordEvent event, Emitter<AuthState> emit) async {
    emit(RegisterLoadingState());

    final result = await authRepository.registerWithEmailAndPassword(
        emailAndPasswordRegistrationForm: event.form);
    result.fold((l) {
      emit(AuthErrorState(exception: l));
    }, (r) {
      emit(RegisterSuccessState());
    });
  }
}
