import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/base_dashboard_services.dart';

class DashboardRemoteServices implements BaseDashboardServices {
  @override
  Future<Either<Exception, Report>> getUsageReport() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getUsageReport + ApiManager.userId!,
      );
      return Right(Report.fromJson(response.data));
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
