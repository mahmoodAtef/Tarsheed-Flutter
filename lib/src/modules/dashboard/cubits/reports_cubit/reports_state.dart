part of 'reports_cubit.dart';

sealed class ReportsState extends Equatable {
  final Report? report;
  final AIRecommendations? aiSuggestions;
  const ReportsState({this.report, this.aiSuggestions});
}

final class ReportsInitial extends ReportsState {
  @override
  List<Object> get props => [];
}

final class GetUsageReportLoading extends ReportsState {
  const GetUsageReportLoading({super.report});
  @override
  List<Object?> get props => [];
}

final class GetUsageReportSuccess extends ReportsState {
  const GetUsageReportSuccess({required super.report});

  @override
  List<Object?> get props => [super.report];
}

final class GetUsageReportError extends ReportsState {
  final Exception exception;
  const GetUsageReportError(this.exception, {super.report});
  @override
  List<Object?> get props => [exception];
}

// ai suggestions
class AISuggestionsState extends ReportsState {
  const AISuggestionsState({super.report});
  @override
  List<Object?> get props => [];
}

final class GetAISuggestionsLoading extends AISuggestionsState {
  const GetAISuggestionsLoading({super.report});
}

final class GetAISuggestionsSuccess extends AISuggestionsState {
  final AIRecommendations suggestion;
  const GetAISuggestionsSuccess(this.suggestion, {super.report});
  @override
  List<Object?> get props => [suggestion];
}

final class GetAISuggestionsError extends AISuggestionsState {
  final Exception exception;
  const GetAISuggestionsError(this.exception, {super.report});
  @override
  List<Object?> get props => [exception];
}
