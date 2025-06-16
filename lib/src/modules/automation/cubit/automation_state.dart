part of 'automation_cubit.dart';

sealed class AutomationState extends Equatable {
  final List<Automation>? automations;
  const AutomationState({this.automations});

  @override
  List<Object> get props => [automations ?? []];
}

final class AutomationInitial extends AutomationState {
  @override
  List<Object> get props => [];
}

final class GetAllAutomationsLoading extends AutomationState {
  const GetAllAutomationsLoading({super.automations});
  @override
  List<Object> get props => [];
}

final class GetAllAutomationsSuccess extends AutomationState {
  const GetAllAutomationsSuccess({required super.automations});
  @override
  List<Object> get props => [];
}

final class GetAllAutomationsError extends AutomationState {
  final Exception exception;
  const GetAllAutomationsError({super.automations, required this.exception});
  @override
  List<Object> get props => [];
}

final class ChangeAutomationStatusLoading extends AutomationState {
  const ChangeAutomationStatusLoading({super.automations});
  @override
  List<Object> get props => [];
}

final class ChangeAutomationStatusSuccess extends AutomationState {
  const ChangeAutomationStatusSuccess({super.automations});
  @override
  List<Object> get props => [];
}

final class ChangeAutomationStatusError extends AutomationState {
  final Exception exception;
  const ChangeAutomationStatusError(
      {super.automations, required this.exception});
  @override
  List<Object> get props => [];
}

final class DeleteAutomationLoading extends AutomationState {
  const DeleteAutomationLoading({super.automations});
  @override
  List<Object> get props => [];
}

final class DeleteAutomationSuccess extends AutomationState {
  const DeleteAutomationSuccess({super.automations});
  @override
  List<Object> get props => [];
}

final class DeleteAutomationError extends AutomationState {
  final Exception exception;
  const DeleteAutomationError({super.automations, required this.exception});
  @override
  List<Object> get props => [];
}

final class AddAutomationLoading extends AutomationState {
  const AddAutomationLoading({super.automations});
  @override
  List<Object> get props => [];
}

final class AddAutomationSuccess extends AutomationState {
  const AddAutomationSuccess({super.automations});
  @override
  List<Object> get props => [];
}

final class AddAutomationError extends AutomationState {
  final Exception exception;
  const AddAutomationError({super.automations, required this.exception});
  @override
  List<Object> get props => [];
}

final class UpdateAutomationLoading extends AutomationState {
  const UpdateAutomationLoading({super.automations});
  @override
  List<Object> get props => [];
}

final class UpdateAutomationSuccess extends AutomationState {
  const UpdateAutomationSuccess({super.automations});
  @override
  List<Object> get props => [];
}

final class UpdateAutomationError extends AutomationState {
  final Exception exception;
  const UpdateAutomationError({super.automations, required this.exception});
  @override
  List<Object> get props => [];
}
