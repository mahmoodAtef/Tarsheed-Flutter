import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/modules/auth/data/models/email_and_password_registration_form.dart';
import 'package:tarsheed/src/modules/auth/data/models/user.dart';

abstract class BaseAuthRemoteServices {
  Future<Either<Exception, User>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm});
}

class AuthRemoteServices extends BaseAuthRemoteServices {
  @override
  Future<Either<Exception, User>> registerWithEmailAndPassword(
      {required EmailAndPasswordRegistrationForm registrationForm}) async {
    try {
      var response = await DioHelper.postData(
          path: EndPoints.register, data: registrationForm.toJson());
      // Todo : Handle response

      return Right(User(id: 1));
    } on DioException catch (e) {
      AuthException exception = e as AuthException;
      return Left(exception);
    }
  }
}
