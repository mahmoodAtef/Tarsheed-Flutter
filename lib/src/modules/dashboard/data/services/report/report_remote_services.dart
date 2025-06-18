import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/ai_recommendations.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';

abstract class BaseReportService {
  Future<Either<Exception, Report>> getUsageReport({String? period});
  Future<Either<Exception, AIRecommendations>> getAIRecommendations();
}

class ReportRemoteServices implements BaseReportService {
  @override
  Future<Either<Exception, Report>> getUsageReport({String? period}) async {
    try {
      var response = await DioHelper.getData(
        query: {"targetPeriod": period},
        path: EndPoints.getUsageReport,
      );
      return Right(Report.fromJson(response.data));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, AIRecommendations>> getAIRecommendations() async {
    try {
      var response = await DioHelper.getData(
        path: EndPoints.getAISuggestions,
        query: {"lang": LocalizationManager.getLanguageName()},
      );

      return Right(
        AIRecommendations.fromJson(response.data["recommendations"]),
      );
    } on DioException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
