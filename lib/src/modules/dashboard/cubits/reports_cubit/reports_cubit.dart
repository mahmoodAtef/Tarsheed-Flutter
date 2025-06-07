import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/ai_recommendations.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/report/report_repository.dart';

import '../../data/models/report.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository _repository;

  Report? report;

  ReportsCubit(this._repository) : super(ReportsInitial());

  Future<void> getUsageReport(
      {required String period, bool isRefresh = false}) async {
    if (report == null || isRefresh) {
      emit(const GetUsageReportLoading());
      final result = await _repository.getUsageReport(period: period);
      result.fold(
        (e) => emit(GetUsageReportError(e)),
        (r) {
          report = r;
          emit(GetUsageReportSuccess(report: r));
        },
      );
    } else {
      emit(GetUsageReportSuccess(report: report!));
    }
  }

  Future<void> getAISuggestions() async {
    var lastReport = state.report;
    emit(GetAISuggestionsLoading(report: lastReport));
    final result = await _repository.getAISuggestion();
    result.fold(
      (e) => emit(GetAISuggestionsError(e, report: lastReport)),
      (r) => emit(GetAISuggestionsSuccess(r, report: lastReport)),
    );
  }

  void clearData() {
    report = null;
  }
}
