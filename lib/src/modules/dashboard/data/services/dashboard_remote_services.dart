import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
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
}

/**/
