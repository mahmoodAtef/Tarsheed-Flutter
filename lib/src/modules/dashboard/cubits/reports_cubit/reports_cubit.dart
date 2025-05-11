import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());
}
