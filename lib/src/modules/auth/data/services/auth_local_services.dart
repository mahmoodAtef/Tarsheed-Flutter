import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/local/secure_storage_helper.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';

abstract class BaseAuthLocalServices {
  Future<void> saveAuthInfo(AuthInfo info);
  Future<Either<Exception, Unit>> logout();
}

class AuthLocalServices extends BaseAuthLocalServices {
  @override
  Future<void> saveAuthInfo(AuthInfo info) async {
    Future.wait([
      SecureStorageHelper.saveData(
          key: "token",
          value: info.accessToken,
          expiresAfter: Duration(
            days: 29,
            hours: 23,
            minutes: 59,
          )),
      SecureStorageHelper.saveData(
          key: "id",
          value: info.userId,
          expiresAfter: Duration(
            days: 29,
            hours: 23,
            minutes: 59,
          )),
    ]).catchError((e) =>
        [printException(e as Exception, process: "saving auth info"), throw e]);
  }

  Future<Either<Exception, Unit>> logout() async {
    try {
      await SecureStorageHelper.removeData(key: "token");
      await SecureStorageHelper.removeData(key: "id");
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
