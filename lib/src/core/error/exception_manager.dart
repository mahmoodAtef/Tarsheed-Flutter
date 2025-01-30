import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/core/error/handlers/auth_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/dio_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/unexpected_exception_handler.dart';

abstract class ExceptionHandler {
  String handle(Exception exception);
}

class ExceptionManager {
  final Map<Type, ExceptionHandler> _handlers = <Type, ExceptionHandler>{
    DioException: DioExceptionHandler(),
    AuthException: AuthExceptionHandler(),
    UnexpectedExceptionHandler: UnexpectedExceptionHandler(),
  };

  String getMessage(Exception exception) {
    return _handlers[exception.runtimeType]?.handle(exception) ??
        _handlers[UnexpectedExceptionHandler]!.handle(exception);
  }
}

void printException(Exception exception, {String? process}) {
  debugPrint(
      "****************************** Error While $process *****************************");
  if (exception is DioException) {
    debugPrint("response : ${exception.response?.data} \n "
        "response status code : ${exception.response?.statusCode}\n message : ${exception.response?.statusMessage} \n "
        "exception message : ${exception.message} \n ");
  } else {
    debugPrint("exception message : ${exception.toString()} \n ");
  }
  debugPrint(
      "**********************************************************************************");
}
