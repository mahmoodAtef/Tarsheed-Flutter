import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';

class UnexpectedExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    return LocalizationManager.getCurrentLocale().languageCode == "ar"
        ? "حدث خطاء غير متوقع"
        : "Unexpected error";
  }

  @override
  String getIconPath(Exception exception) {
    return AssetsManager.errorIcon;
  }
}
