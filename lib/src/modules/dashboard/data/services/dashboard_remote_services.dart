import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/base_dashboard_services.dart';

class DashboardRemoteServices implements BaseDashboardServices {
  @override
  Future<Either<Exception, Report>> getUsageReport() async {
    try {
      // TODO: implement getUsageReport
      throw UnimplementedError();
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
