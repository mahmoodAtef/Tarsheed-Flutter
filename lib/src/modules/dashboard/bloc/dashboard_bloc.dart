import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository = sl()..initialize();

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {
      if (event is GetUsageReportEvent) {
        _handleGetUsageReportEvent(event, emit);
      }
    });
  }

  _handleGetUsageReportEvent(
      GetUsageReportEvent event, Emitter<DashboardState> emit) async {
    emit(GetUsageReportLoading());
    var result = await _repository.getUsageReport();
    result.fold((l) => emit(GetUsageReportError(l)),
        (r) => emit(GetUsageReportSuccess(r)));
    _subscribeToReport();
  }

  _subscribeToReport() {
    _repository.reportStream.listen(_updateReport);
  }

  _updateReport(Report report) {
    add(UpdateUsageReportEvent(usageReport: report));
  }
}
