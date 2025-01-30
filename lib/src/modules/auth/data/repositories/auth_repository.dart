import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';
import 'package:tarsheed/src/modules/auth/data/models/user.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';

class AuthRepository {
  BaseAuthRemoteServices _authRemoteServices;
  AuthRepository(this._authRemoteServices);

  Future<Either<Exception, User>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm
          emailAndPasswordRegistrationForm}) {
    return _authRemoteServices.registerWithEmailAndPassword(
        registrationForm: emailAndPasswordRegistrationForm);
  }

  Future<Either<Exception, User>> loginWithEmailAndPassword(
      {required String email, required String password}) {
    return _authRemoteServices.loginWithEmailAndPassword(
        email: email, password: password);
  }

  Future<Either<Exception, User>> loginWithGoogle() {
    return _authRemoteServices.loginWithGoogle();
  }

  Future<Either<Exception, User>> loginWithFacebook() {
    return _authRemoteServices.loginWithFacebook();
  }

  Future<Either<Exception, User>> registerWithGoogle() {
    return _authRemoteServices.registerWithGoogle();
  }

  Future<Either<Exception, User>> registerWithFacebook() {
    return _authRemoteServices.registerWithFacebook();
  }

  Future<Either<Exception, Unit>> updateUser(User user) {
    return _authRemoteServices.updateUser(user);
  }
}
