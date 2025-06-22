import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/services/secure_storage_helper.dart';
import 'package:tarsheed/src/modules/auth/data/models/auth_info.dart';

abstract class BaseAuthLocalServices {
  Future<void> saveAuthInfo(AuthInfo info);
  Future<Either<Exception, Unit>> logout();
}

class AuthLocalServices extends BaseAuthLocalServices {
  final LocalAuthentication auth;
  AuthLocalServices({required this.auth});

  @override
  Future<void> saveAuthInfo(AuthInfo info) async {
    await SecureStorageHelper.saveData(
        key: "auth_info",
        value: jsonEncode(info.toJson()),
        expiresAfter: Duration(
          days: 29,
          hours: 23,
          minutes: 59,
        ));
  }

  @override
  Future<Either<Exception, Unit>> logout() async {
    try {
      await SecureStorageHelper.removeData(key: "auth_info");
      ApiManager.userId = null;
      ApiManager.authToken = null;
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
