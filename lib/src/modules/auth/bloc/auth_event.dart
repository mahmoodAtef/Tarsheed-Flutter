part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class RegisterWithEmailAndPasswordEvent extends AuthEvent {
  final EmailAndPasswordRegistrationForm form;
  const RegisterWithEmailAndPasswordEvent({required this.form});
  @override
  List<Object?> get props => [form];
}
