import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart' as db;
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/base_dashboard_services.dart';

class DashboardLocalServices implements BaseDashboardServices {
  late db.Database database;
  DashboardLocalServices();
  initializeDatabase() async {
    database = await db.openDatabase('tarsheed.db');
  }

  @override
  Future<Either<Exception, Report>> getUsageReport({int? period}) async {
    try {
      List<Map<String, dynamic>> result;

      if (period != null) {
        result = await database.query(
          'reports',
          where: 'period = ?',
          whereArgs: [period],
        );
      } else {
        result = await database.query(
          'reports',
          orderBy: 'updatedAt DESC',
          limit: 1,
        );
      }

      Report report = Report.fromJson(result.first);
      return Right(report);
    } on db.DatabaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> saveUsageReport(Report report) async {
    try {
      // check if report exists for this period and update it if it does or insert if it doesn't
      var existingReport = await database.query(
        'reports',
        where: 'period = ?',
        whereArgs: [report.period],
      );
      if (existingReport.isNotEmpty) {
        await database.update(
          'reports',
          report.toJson(),
          where: 'period = ?',
          whereArgs: [report.period],
        );
      } else {
        await database.insert('reports', report.toJson());
      }
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<DeviceCategory>>> getCategories() async {
    try {
      List<Map<String, dynamic>> result = await database.query('categories');
      List<DeviceCategory> categories =
          result.map((e) => DeviceCategory.fromJson(e)).toList();
      return Right(categories);
    } on db.DatabaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> saveCategories(
      List<DeviceCategory> categories) async {
    try {
      await database.delete('categories');
      for (var category in categories) {
        await database.insert('categories', category.toJson());
      }
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Sensor>>> getSensors() async {
    try {
      List<Map<String, dynamic>> result = await database.query('sensors');
      List<Sensor> sensors = result.map((e) => Sensor.fromJson(e)).toList();
      return Right(sensors);
    } on db.DatabaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Unit>> saveSensors(List<Sensor> sensors) async {
    try {
      await database.delete('sensors');
      for (var sensor in sensors) {
        await database.insert('sensors', sensor.toJson());
      }
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Device>>> getDevices() {
    // TODO: implement getDevices
    throw UnimplementedError();
  }

  Future<Either<Exception, Unit>> saveDevices(List<Device> devices) async {
    try {
      await database.delete('devices');
      for (var device in devices) {
        await database.insert('devices', device.toJson());
      }
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Room>>> getRooms() {
    // TODO: implement getRooms
    throw UnimplementedError();
  }

  Future<Either<Exception, Unit>> saveRooms(List<Room> rooms) async {
    try {
      await database.delete('rooms');
      for (var room in rooms) {
        await database.insert('rooms', room.toJson());
      }
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, String>> getAISuggestions() async {
    try {
      var result = await database.query('aisuggestions');
      return Right(result.first['suggestions'].toString());
    } on db.DatabaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
