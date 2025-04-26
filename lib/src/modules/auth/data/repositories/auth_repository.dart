import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';
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
    return remoteResult.fold(
      (exception) => Left(exception),
      (authInfo) async => await _saveAuthInfo(authInfo),
    );
  }

  Future<Either<Exception, Unit>> verifyEmail({
    required String code,
  }) async {
    final remoteResult = await _authRemoteServices.verifyEmail(
      code: code,
    );
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

  Future<Either<Exception, Unit>> updatePassword(
      {required String newPassword, required String oldPassword}) async {
    return await _authRemoteServices.updatePassword(
      oldPassword,
      newPassword,
    );
  }

  Future<Either<Exception, Unit>> forgetPassword(
      {required String email}) async {
    return await _authRemoteServices.forgetPassword(
      email: email,
    );
  }

  Future<Either<Exception, Unit>> confirmForgotPasswordCode({
    required String code,
  }) async {
    return await _authRemoteServices.confirmForgotPasswordCode(
      code: code,
    );
  }

  Future<Either<Exception, Unit>> loginWithGoogle() async {
    final remoteResult = await _authRemoteServices.loginWithGoogle();
    return remoteResult.fold(
      (exception) => Left(exception),
      (authInfo) async => await _saveAuthInfo(authInfo),
    );
  }

  Future<Either<Exception, Unit>> loginWithFacebook() async {
    final remoteResult = await _authRemoteServices.loginWithFacebook();
    return remoteResult.fold(
      (exception) => Left(exception),
      (authInfo) async => await _saveAuthInfo(authInfo),
    );
  }

  Future<Either<Exception, Unit>> logout() async {
    return _authLocalServices.logout();
  }

  Future<Either<Exception, Unit>> _saveAuthInfo(AuthInfo authInfo) async {
    try {
      ApiManager.authToken = authInfo.accessToken;
      ApiManager.userId = authInfo.userId;
      debugPrint(ApiManager.userId);
      DioHelper.setToken(ApiManager.authToken!);
      await _authLocalServices.saveAuthInfo(authInfo);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
