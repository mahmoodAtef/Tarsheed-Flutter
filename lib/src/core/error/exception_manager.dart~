import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tarsheed/src/core/error/custom_exceptions/auth_exceptions.dart';
import 'package:tarsheed/src/core/error/handlers/auth_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/dio_exception_handler.dart';
import 'package:tarsheed/src/core/error/handlers/unexpected_exception_handler.dart';
import 'package:tarsheed/src/core/utils/theme_manager.dart';

abstract class ExceptionHandler {
  String handle(Exception exception);
}

class ExceptionManager {
  static final Map<Type, ExceptionHandler> _handlers = <Type, ExceptionHandler>{
    DioException: DioExceptionHandler(),
    AuthException: AuthExceptionHandler(),
    UnexpectedExceptionHandler: UnexpectedExceptionHandler(),
  };

  static String getMessage(Exception exception) {
    return _handlers[exception.runtimeType]?.handle(exception) ??
        _handlers[UnexpectedExceptionHandler]!.handle(exception);
  }

  static void showMessage(Exception exception) {
    Fluttertoast.showToast(
        msg: getMessage(exception), backgroundColor: ThemeManager.errorColor);
  }
}
