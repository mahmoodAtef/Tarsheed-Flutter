import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/services/connectivity_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_creation_form.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_local_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_remote_services.dart';

class DashboardRepository {
  final DashboardRemoteServices _remoteServices;
  final DashboardLocalServices _localServices; // نحتفظ بها لتجنب تغيير الـ DI

  DashboardRepository(this._remoteServices, this._localServices,
      ConnectivityService connectivityService);

  void initialize() {
    // TODO: use it after reusing offline first
    _localServices.initializeDatabase();
  }

  Future<void> dispose() async {
    // TODO: use it after reusing offline first
  }

  // Usage Report
  Future<Either<Exception, Report>> getUsageReport({int? period}) async {
    return await _remoteServices.getUsageReport(period: period);
  }

  // AI Suggestions
  Future<Either<Exception, String>> getAISuggestion() async {
    return await _remoteServices.getAISuggestions();
  }

  // Devices
  Future<Either<Exception, List<Device>>> getDevices() async {
    return await _remoteServices.getDevices();
  }

  Future<Either<Exception, Device>> addDevice(DeviceCreationForm device) async {
    return await _remoteServices.addDevice(device);
  }

  Future<Either<Exception, Unit>> editDevice(
      {required String id,
      String? name,
      String? description,
      String? pinNumber}) async {
    return await _remoteServices.editDevice(
        id: id, name: name, description: description, pinNumber: pinNumber);
  }

  Future<Either<Exception, Unit>> deleteDevice(String id) async {
    return await _remoteServices.deleteDevice(id);
  }

  // Categories
  Future<Either<Exception, List<DeviceCategory>>> getCategories() async {
    return await _remoteServices.getCategories();
  }

  // Rooms
  Future<Either<Exception, List<Room>>> getRooms() async {
    return await _remoteServices.getRooms();
  }

  Future<Either<Exception, Room>> addRoom(Room room) async {
    return await _remoteServices.addRoom(room);
  }

  Future<Either<Exception, Unit>> deleteRoom(String id) async {
    return await _remoteServices.deleteRoom(id);
  }

  // Sensors
  Future<Either<Exception, List<Sensor>>> getSensors() async {
    return await _remoteServices.getSensors();
  }

  Future<Either<Exception, Sensor>> addSensor(Sensor sensor) async {
    return await _remoteServices.addSensor(sensor);
  }

  Future<Either<Exception, Unit>> editSensor(
      {required String id,
      String? name,
      String? description,
      String? pinNumber}) async {
    return await _remoteServices.editSensor(
        id: id, name: name, description: description, pinNumber: pinNumber);
  }

  Future<Either<Exception, Unit>> deleteSensor(String id) async {
    return await _remoteServices.deleteSensor(id);
  }
}
