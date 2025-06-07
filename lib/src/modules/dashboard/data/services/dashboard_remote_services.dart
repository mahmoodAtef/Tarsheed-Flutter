import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_creation_form.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/base_dashboard_services.dart';

class DashboardRemoteServices implements BaseDashboardServices {
  @override
  Future<Either<Exception, List<DeviceCategory>>> getCategories() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getCategories,
      );
      List<DeviceCategory> categories = (response.data["categories"] as List)
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
      List<Sensor> sensors = (response.data["sensors"] as List)
          .map((e) => Sensor.fromJson(e))
          .toList();
      return Right(sensors);
    } on DioException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Device>>> getDevices() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getDevices + ApiManager.userId!,
      );
      List<Device> devices = (response.data["devices"] as List)
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
      List<Room> rooms = (response.data["rooms"] as List)
          .map((e) => Room.fromJson(e))
          .toList();
      return Right(rooms);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Device>> addDevice(DeviceCreationForm device) async {
    try {
      var response = await DioHelper.postData(
        path: EndPoints.addDevice,
        data: device.toJson(),
      );
      Device savedDevice = Device.fromJson(response.data["deviceSaved"]);
      return Right(savedDevice);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> editDevice(
      {required String id,
      String? name,
      String? description,
      String? pinNumber}) async {
    try {
      await DioHelper.putData(
        path: EndPoints.editDevice + id,
        query: {"deviceId": id},
        data: {
          "name": name,
          "description": description,
          "pinNumber": pinNumber
        },
      );
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> deleteDevice(String id) async {
    try {
      await DioHelper.deleteData(
        path: EndPoints.deleteDevice + id,
      );
      return Right(unit);
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

  Future<Either<Exception, Unit>> deleteRoom(String id) async {
    try {
      await DioHelper.deleteData(
        path: EndPoints.deleteRoom + id,
      );
      return Right(unit);
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
      Sensor savedSensor = sensor.copyWith(id: response.data["sensor"]["_id"]);
      return Right(savedSensor);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> deleteSensor(String id) async {
    try {
      await DioHelper.deleteData(
        path: EndPoints.deleteSensor + id,
      );
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> editSensor(
      {required String id,
      String? name,
      String? description,
      String? pinNumber}) async {
    try {
      await DioHelper.putData(
        path: EndPoints.editDevice + id,
        query: {"id": id},
        data: {
          "name": name,
          "description": description,
          "pinNumber": pinNumber
        },
      );
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
