import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';

abstract class BaseDashboardServices {
  Future<Either<Exception, List<DeviceCategory>>> getCategories();
  Future<Either<Exception, List<Sensor>>> getSensors();
  Future<Either<Exception, List<Device>>> getDevices();
  Future<Either<Exception, List<Room>>> getRooms();
}
