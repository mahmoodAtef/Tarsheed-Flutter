import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/local/secure_storage_helper.dart';
import 'package:tarsheed/src/modules/settings/data/models/security_settings.dart';

abstract class BaseSettingsLocalServices {
  Future<Either<Exception, Unit>> saveSecuritySettings(
      SecuritySettings settings);
  Future<Either<Exception, SecuritySettings>> getSecuritySettings();
}

class SettingsLocalServices extends BaseSettingsLocalServices {
  @override
  Future<Either<Exception, Unit>> saveSecuritySettings(
      SecuritySettings settings) async {
    try {
      await SecureStorageHelper.saveData(
          key: "security_settings", value: jsonEncode(settings.toJson()));
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, SecuritySettings>> getSecuritySettings() async {
    try {
      var data = await SecureStorageHelper.getData(key: "security_settings");
      return Right(SecuritySettings.fromJson(jsonDecode(data!)));
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
