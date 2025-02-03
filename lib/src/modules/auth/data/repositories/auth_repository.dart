import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';
import 'package:tarsheed/src/modules/auth/data/models/user.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_local_services.dart';
import 'package:tarsheed/src/modules/auth/data/services/auth_remote_services.dart';

class AuthRepository {
  final BaseAuthRemoteServices _authRemoteServices;
  final BaseAuthLocalServices _authLocalServices;
  AuthRepository(this._authRemoteServices, this._authLocalServices);

  Future<Either<Exception, Unit>> registerWithEmailAndPassword({
    required EmailAndPasswordRegistrationForm registrationForm,
  }) async {
    final remoteResult = await _authRemoteServices.registerWithEmailAndPassword(
      registrationForm: registrationForm,
    );
    return await remoteResult.fold(
      (exception) => Left(exception),
      (authInfo) async => await _saveAuthInfo(authInfo),
    );
  }

  Future<Either<Exception, Unit>> verifyEmail({required String code}) async {
    final remoteResult = await _authRemoteServices.verifyEmail(code: code);
    return await remoteResult.fold(
      (exception) => Left(exception),
      (unit) => Right(unit),
    );
  }

  Future<Either<Exception, Unit>> resendEmailVerificationCode() async {
    return _authRemoteServices.resendEmailVerificationCode();
  }

  Future<Either<Exception, Unit>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    final remoteResult = await _authRemoteServices.loginWithEmailAndPassword(
        email: email, password: password);
    return await remoteResult.fold(
      (exception) => Left(exception),
      (authInfo) async => await _saveAuthInfo(authInfo),
    );
  }

  Future<Either<Exception, Unit>> resetPassword(String newPassword) async {
    return await _authRemoteServices.resetPassword(
      newPassword,
    );
  }

  Future<Either<Exception, Unit>> forgetPassword(
      {required String email}) async {
    return await _authRemoteServices.forgetPassword(email: email);
  }

  Future<Either<Exception, Unit>> confirmForgotPasswordCode(
      {required String code}) async {
    return await _authRemoteServices.confirmForgotPasswordCode(code: code);
  }

  Future<Either<Exception, Unit>> loginWithGoogle() {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  Future<Either<Exception, Unit>> loginWithFacebook() {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  Future<Either<Exception, Unit>> registerWithGoogle() {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  Future<Either<Exception, Unit>> registerWithFacebook() {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  Future<Either<Exception, Unit>> updateUser(User user) {
    return _authRemoteServices.updateUser(user);
  }

  Future<Either<Exception, Unit>> logout() async {
    return _authLocalServices.logout();
  }

  Future<Either<Exception, Unit>> _saveAuthInfo(authInfo) async {
    try {
      await _authLocalServices.saveAuthInfo(authInfo);
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
