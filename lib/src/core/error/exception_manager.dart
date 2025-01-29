import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/core/error/handlers/auth_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/dio_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/unexpected_exception_handler.dart';

abstract class ExceptionHandler {
  String handle(Exception exception);
}

class ExceptionManager {
  final _handlers = <Type, ExceptionHandler>{
    DioException: DioExceptionHandler(),
    AuthException: AuthExceptionHandler(),
    FallbackExceptionHandler: FallbackExceptionHandler(),
  };

  String getMessage(Exception exception) {
    return _handlers[exception.runtimeType]?.handle(exception) ??
        _handlers[FallbackExceptionHandler]!.handle(exception);
  }
}
