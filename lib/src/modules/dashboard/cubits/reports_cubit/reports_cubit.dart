import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/ai_recommendations.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/report/report_repository.dart';

import '../../data/models/report.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository _repository;

  ReportsCubit(this._repository) : super(ReportsInitial());

  static ReportsCubit get() {
    if (sl<ReportsCubit>().isClosed) {
      sl.unregister<ReportsCubit>();
      sl.registerLazySingleton<ReportsCubit>(
        () => ReportsCubit(sl<ReportsRepository>()),
      );
    }
    return sl<ReportsCubit>();
  }

  @override
  Future<void> close() async {
    debugPrint('Closing ReportsCubit');
    // Perform any necessary cleanup here
    // return super.close();
  }

  Future<void> getUsageReport(
      {required String period, bool isRefresh = false}) async {
    if (state.report == null || isRefresh) {
      emit(const GetUsageReportLoading());
      final result = await _repository.getUsageReport(period: period);
      result.fold(
        (e) => emit(GetUsageReportError(e)),
        (r) {
          emit(GetUsageReportSuccess(report: r));
        },
      );
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
}
