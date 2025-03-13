import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/base_dashboard_services.dart';

class DashboardLocalServices implements BaseDashboardServices {
  @override
  Future<Either<Exception, Report>> getUsageReport() {
    // TODO: implement getUsageReport
    throw UnimplementedError();
  }
}
