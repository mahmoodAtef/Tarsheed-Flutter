import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';
import 'package:tarsheed/src/modules/auth/data/models/user.dart';

abstract class BaseAuthRemoteServices {
  Future<Either<Exception, User>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm});
  Future<Either<Exception, User>> loginWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Exception, User>> loginWithGoogle();
  Future<Either<Exception, User>> loginWithFacebook();
  Future<Either<Exception, User>> registerWithFacebook();
  Future<Either<Exception, User>> registerWithGoogle();
  Future<Either<Exception, Unit>> updateUser(User user);
}

class AuthRemoteServices extends BaseAuthRemoteServices {
  @override
  Future<Either<Exception, User>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm}) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.register, data: registrationForm.toJson());
      return Right(User.fromJson(response.data));
    } on DioException catch (e) {
      printException(e, process: "registering user");
      AuthException exception = e as AuthException;
      return Left(exception);
    } on Exception catch (e) {
      printException(e, process: "registering user");
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, User>> loginWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, User>> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, User>> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, User>> registerWithFacebook() {
    // TODO: implement registerWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, User>> registerWithGoogle() {
    // TODO: implement registerWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, Unit>> updateUser(User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
