part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  final Exception exception;

  const AuthErrorState({required this.exception});
  @override
  List<Object> get props => [];
}

final class RegisterLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

final class RegisterSuccessState extends AuthState {
  // TODO: implement props based on Api response data
  @override
  List<Object> get props => [];
}
