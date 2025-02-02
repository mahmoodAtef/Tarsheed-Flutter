import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/local/secure_storage_helper.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';

abstract class BaseAuthLocalServices {
  Future<void> saveAuthInfo(AuthInfo info);
}

class AuthLocalServices extends BaseAuthLocalServices {
  @override
  Future<void> saveAuthInfo(AuthInfo info) async {
    Future.wait([
      SecureStorageHelper.saveData(key: "token", value: info.accessToken),
      SecureStorageHelper.saveData(key: "id", value: info.userId),
    ]).catchError(
        (e) => [printException(e as Exception, process: "saving auth info")]);
  }
}
