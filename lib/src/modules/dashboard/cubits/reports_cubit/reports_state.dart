part of 'reports_cubit.dart';

sealed class ReportsState extends Equatable {
  const ReportsState();
}

final class ReportsInitial extends ReportsState {
  @override
  List<Object> get props => [];
}
