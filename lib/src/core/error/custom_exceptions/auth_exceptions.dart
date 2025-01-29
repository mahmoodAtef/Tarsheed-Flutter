import 'package:dio/dio.dart';

class AuthException extends DioException {
  AuthException({required super.requestOptions});
}
