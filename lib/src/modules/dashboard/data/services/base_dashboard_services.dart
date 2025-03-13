import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';

abstract class BaseDashboardServices {
  Future<Either<Exception, Report>> getUsageReport();
}
