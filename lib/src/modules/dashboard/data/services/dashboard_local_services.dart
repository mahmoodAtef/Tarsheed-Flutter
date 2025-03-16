import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart' as db;
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/base_dashboard_services.dart';

class DashboardLocalServices implements BaseDashboardServices {
  late db.Database database;
  DashboardLocalServices();
  initializeDatabase() async {
    database = await db.openDatabase('tarsheed.db');
  }

  @override
  Future<Either<Exception, Report>> getUsageReport() async {
    try {
      var result = await database.query('reports');
      Report report = Report.fromJson(result.first);
      return Right(report);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future saveUsageReport(Report report) async {
    await database.insert('reports', report.toJson());
  }
}
