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
}
