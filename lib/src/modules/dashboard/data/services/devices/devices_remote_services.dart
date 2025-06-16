import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_creation_form.dart';

abstract class BaseDevicesRemoteServices {
  Future<Either<Exception, List<Device>>> getDevices();
  Future<Either<Exception, Device>> addDevice(DeviceCreationForm form);
  Future<Either<Exception, Unit>> editDevice({
    required String id,
    String? name,
    String? description,
    String? pinNumber,
  });
  Future<Either<Exception, Unit>> deleteDevice(String id);
}

class DevicesRemoteServices implements BaseDevicesRemoteServices {
  @override
  Future<Either<Exception, List<Device>>> getDevices() async {
    try {
      final response = await DioHelper.getData(
        path: "${EndPoints.getDevices}${ApiManager.userId}",
      );
      final List<Device> devices = (response.data['devices'] as List)
          .map((e) => Device.fromJson(e))
          .toList();
      return Right(devices);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Device>> addDevice(DeviceCreationForm form) async {
    try {
      final response = await DioHelper.postData(
        path: EndPoints.addDevice,
        data: form.toJson(),
      );
      final Device device = Device.fromJson(response.data['deviceSaved']);
      return Right(device);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, Unit>> editDevice({
    required String id,
    String? name,
    String? description,
    String? pinNumber,
  }) async {
    try {
      await DioHelper.putData(
        path: EndPoints.editDevice + id,
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (pinNumber != null) 'pinNumber': pinNumber,
        },
      );
      return Right(unit);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteDevice(String id) async {
    try {
      await DioHelper.deleteData(
        path: EndPoints.deleteDevice + id,
      );
      return Right(unit);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  Future<Either<Exception, Unit>> toggleDeviceStatus(String id) async {
    try {
      await DioHelper.patchData(
          path: EndPoints.toggleDeviceStatus + id, data: {});
      return Right(unit);
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
