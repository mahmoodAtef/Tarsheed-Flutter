part of 'automation_cubit.dart';

sealed class AutomationState extends Equatable {
  const AutomationState();
}

final class AutomationInitial extends AutomationState {
  @override
  List<Object> get props => [];
}
