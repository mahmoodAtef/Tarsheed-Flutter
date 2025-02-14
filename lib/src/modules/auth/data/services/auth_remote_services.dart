import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';

abstract class BaseAuthRemoteServices {
  Future<Either<Exception, AuthInfo>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm});
  Future<Either<Exception, Unit>> verifyEmail({required String code});
  Future<Either<Exception, Unit>> confirmForgotPasswordCode(
      {required String code});

  Future<Either<Exception, AuthInfo>> loginWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Exception, Unit>> resendEmailVerificationCode();
  Future<Either<Exception, Unit>> forgetPassword({required String email});
  Future<Either<Exception, Unit>> resetPassword(
    String newPassword,
  );
  Future<Either<Exception, AuthInfo>> loginWithGoogle();
  Future<Either<Exception, AuthInfo>> loginWithFacebook();
  Future<Either<Exception, AuthInfo>> registerWithFacebook();
  Future<Either<Exception, AuthInfo>> registerWithGoogle();
}

class AuthRemoteServices extends BaseAuthRemoteServices {
  @override
  Future<Either<Exception, AuthInfo>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm}) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.register, data: registrationForm.toJson());
      return Right(AuthInfo.fromJson(response.data["data"]));
    } on Exception catch (e) {
      return Left(_classifyException(e,
          process: "registering with email and password"));
    }
  }

  @override
  Future<Either<Exception, Unit>> verifyEmail({required String code}) async {
    try {
      await DioHelper.postData(
          path: EndPoints.verify,
          data: {"id": ApiManager.userId, "code": code});
      return Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e, process: "verifying email with code"));
    }
  }

  @override
  Future<Either<Exception, Unit>> resendEmailVerificationCode() async {
    try {
      await DioHelper.postData(
          path: EndPoints.resendCode + ApiManager.userId!,
          query: {"userId": ApiManager.userId});
      return Right(unit);
    } on Exception catch (e) {
      return Left(
          _classifyException(e, process: "resending email verification code"));
    }
  }

  @override
  Future<Either<Exception, AuthInfo>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.login, data: {"email": email, "password": password});
      return Right(AuthInfo.fromJson(response.data));
    } on Exception catch (e) {
      return Left(
          _classifyException(e, process: "logging in with email and password"));
    }
  }

  @override
  Future<Either<Exception, Unit>> forgetPassword(
      {required String email}) async {
    try {
      await DioHelper.postData(
          path: EndPoints.forgetPassword, data: {"email": email});
      return Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e, process: "forgetting password"));
    }
  }

  @override
  Future<Either<Exception, Unit>> confirmForgotPasswordCode(
      {required String code}) async {
    try {
      await DioHelper.postData(
          path: EndPoints.confirmForgotPasswordCode,
          data: {
            "code": code,
            "id": ApiManager.userId, //
          });
      return Right(unit);
    } on Exception catch (e) {
      return Left(
          _classifyException(e, process: "confirming forgot password code"));
    }
  }

  @override
  Future<Either<Exception, Unit>> resetPassword(String newPassword) async {
    try {
      await DioHelper.patchData(
          path: EndPoints.resetPassword,
          data: {"id": ApiManager.userId!, "new_password": newPassword});
      return Right(unit);
    } on Exception catch (e) {
      return Left(_classifyException(e, process: "resetting password"));
    }
  }

  @override
  Future<Either<Exception, AuthInfo>> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, AuthInfo>> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, AuthInfo>> registerWithFacebook() {
    // TODO: implement registerWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, AuthInfo>> registerWithGoogle() {
    // TODO: implement registerWithGoogle
    throw UnimplementedError();
  }

  _classifyException(Exception exception, {String? process}) {
    {
      if (exception is DioException) {
        AuthException authException =
            AuthException(requestOptions: exception.requestOptions);
        return authException;
      }
      return exception;
    }
  }
}
/*


 */
