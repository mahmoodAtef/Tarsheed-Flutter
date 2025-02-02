import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';
import 'package:tarsheed/src/modules/auth/data/models/user.dart';

abstract class BaseAuthRemoteServices {
  Future<Either<Exception, AuthInfo>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm});
  Future<Either<Exception, AuthInfo>> loginWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Exception, AuthInfo>> loginWithGoogle();
  Future<Either<Exception, AuthInfo>> loginWithFacebook();
  Future<Either<Exception, AuthInfo>> registerWithFacebook();
  Future<Either<Exception, AuthInfo>> registerWithGoogle();
  Future<Either<Exception, Unit>> updateUser(User user);
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
      return Left(
          _returnException(e, process: "registering with email and password"));
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
          _returnException(e, process: "logging in with email and password"));
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

  @override
  Future<Either<Exception, Unit>> updateUser(User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  _returnException(Exception exception, {String? process}) {
    {
      printException(exception, process: process);
      if (exception is DioException) {
        AuthException authException =
            AuthException(requestOptions: exception.requestOptions);
        return authException;
      }
      return exception;
    }
  }
}
