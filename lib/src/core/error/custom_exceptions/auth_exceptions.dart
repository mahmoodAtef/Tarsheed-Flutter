import 'package:dio/dio.dart';

/// This class is used to handle exceptions related to authentication
/// the handler will be used in the [AuthExceptionHandler]
class AuthException extends DioException {
  AuthException({required super.requestOptions});
}
