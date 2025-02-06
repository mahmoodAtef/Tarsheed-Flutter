import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/settings/data/models/user.dart';

abstract class BaseSettingsRemoteServices {
  Future<Either<Exception, User>> getProfile();

  Future<Either<Exception, Unit>> updateProfile(User user);
}

class SettingsRemoteServices extends BaseSettingsRemoteServices {
  @override
  Future<Either<Exception, User>> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, Unit>> updateProfile(User user) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}
