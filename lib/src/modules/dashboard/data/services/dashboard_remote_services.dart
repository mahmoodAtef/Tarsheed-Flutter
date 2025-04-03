import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/base_dashboard_services.dart';

class DashboardRemoteServices implements BaseDashboardServices {
  @override
  Future<Either<Exception, Report>> getUsageReport({int? period}) async {
    try {
      var response = await DioHelper.getData(
        query: {"period": period.toString()},
        path: EndPoints.getUsageReport + ApiManager.userId!,
      );
      return Right(Report.fromJson(response.data));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<DeviceCategory>>> getCategories() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getCategories,
      );
      List<DeviceCategory> categories = (response.data["data"] as List)
          .map((e) => DeviceCategory.fromJson(e))
          .toList();
      return Right(categories);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Sensor>>> getSensors() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getSensors,
      );
      List<Sensor> sensors = (response.data["data"] as List)
          .map((e) => Sensor.fromJson(e))
          .toList();
      return Right(sensors);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Device>>> getDevices() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getDevices,
      );
      List<Device> devices = (response.data["data"] as List)
          .map((e) => Device.fromJson(e))
          .toList();
      return Right(devices);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Room>>> getRooms() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getRooms,
      );
      List<Room> rooms =
          (response.data["data"] as List).map((e) => Room.fromJson(e)).toList();
      return Right(rooms);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Device>> addDevice(Device device) async {
    try {
      var response = await DioHelper.postData(
        path: EndPoints.addDevice,
        data: device.toJson(),
      );
      Device savedDevice =
          device.copyWith(id: response.data["data"]["deviceSaved"]["_id"]);
      return Right(savedDevice);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Room>> addRoom(Room room) async {
    try {
      var response = await DioHelper.postData(
        path: EndPoints.addRoom,
        data: room.toJson(),
      );
      Room savedRoom =
          room.copyWith(id: response.data["data"]["createdRoom"]["_id"]);
      return Right(savedRoom);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Sensor>> addSensor(Sensor sensor) async {
    try {
      var response = await DioHelper.postData(
        path: EndPoints.addSensor,
        data: sensor.toJson(),
      );
      Sensor savedSensor =
          sensor.copyWith(id: response.data["data"]["createdSensor"]["_id"]);
      return Right(savedSensor);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}

/**/
