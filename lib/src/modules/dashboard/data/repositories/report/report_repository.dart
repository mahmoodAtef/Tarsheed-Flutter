import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/ai_recommendations.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/report/report_remote_services.dart';

class ReportsRepository {
  final BaseReportService _remoteServices;
  ReportsRepository(this._remoteServices);

  Report? lastReport;

  Future<Either<Exception, Report>> getUsageReport(
      {String? period, bool forceRefresh = false}) async {
    if (lastReport != null && !forceRefresh) {
      return Right(lastReport!);
    }
    final result = await _remoteServices.getUsageReport(period: period);
    return result.fold(
      (l) => Left(l),
      (r) {
        lastReport = r;
        return Right(r);
      },
    );
  }

  // AI Suggestions
  AIRecommendations? lastAIRecommendations;
  Future<Either<Exception, AIRecommendations>> getAISuggestion(
      {bool forceRefresh = false}) async {
    if (lastAIRecommendations != null && !forceRefresh) {
      return Right(lastAIRecommendations!);
    }
    final result = await _remoteServices.getAIRecommendations();
    return result.fold(
      (l) => Left(l),
      (r) {
        lastAIRecommendations = r;
        return Right(r);
      },
    );
  }

  void clearData() {
    lastReport = null;
    lastAIRecommendations = null;
  }
}
