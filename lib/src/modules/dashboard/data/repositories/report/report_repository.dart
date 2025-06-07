import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/ai_recommendations.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/report/report_remote_services.dart';

class ReportsRepository {
  final BaseReportService _remoteServices;
  const ReportsRepository(this._remoteServices);

  Future<Either<Exception, Report>> getUsageReport({String? period}) async {
    return await _remoteServices.getUsageReport(period: period);
  }

  // AI Suggestions
  Future<Either<Exception, AIRecommendations>> getAISuggestion() async {
    return await _remoteServices.getAIRecommendations();
  }
}
