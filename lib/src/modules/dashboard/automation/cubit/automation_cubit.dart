import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/automation/data/models/automation.dart';
import 'package:tarsheed/src/modules/dashboard/automation/data/repositories/repository.dart';

part 'automation_state.dart';

class AutomationCubit extends Cubit<AutomationState> {
  AutomationCubit() : super(AutomationInitial());
  final _repository = sl<AutomationRepository>();
  Future<void> getAllAutomations() async {
    List<Automation>? currentAutomations = state.automations;
    emit(GetAllAutomationsLoading(automations: currentAutomations));
    final result = await _repository.getAutomations();
    result.fold(
      (err) => emit(GetAllAutomationsError(
          exception: err, automations: currentAutomations)),
      (automations) => emit(GetAllAutomationsSuccess(automations: automations)),
    );
  }

  Future<void> addAutomation(Automation automation) async {
    List<Automation>? currentAutomations = state.automations;
    emit(AddAutomationLoading());
    final result = await _repository.addAutomation(automation);
    result.fold(
      (err) => emit(AddAutomationError(exception: err)),
      (automation) => emit(AddAutomationSuccess(
        automations: [automation] + (currentAutomations ?? []),
      )),
    );
  }

  Future<void> updateAutomation(Automation automation) async {
    List<Automation>? currentAutomations = state.automations;
    emit(UpdateAutomationLoading());
    final result = await _repository.updateAutomation(automation);
    result.fold(
      (err) => emit(UpdateAutomationError(exception: err)),
      (automation) => emit(UpdateAutomationSuccess(
        automations: [automation] + (currentAutomations ?? []),
      )),
    );
  }

  Future<void> deleteAutomation(String id) async {
    List<Automation>? currentAutomations = state.automations;
    emit(DeleteAutomationLoading());
    final result = await _repository.deleteAutomation(id);
    result.fold(
      (err) => emit(DeleteAutomationError(exception: err)),
      (automation) => emit(DeleteAutomationSuccess(
        automations: currentAutomations?.where((e) => e.id != id).toList(),
      )),
    );
  }

  Future<void> changeAutomationStatus(String id) async {
    List<Automation>? currentAutomations = state.automations;
    emit(ChangeAutomationStatusLoading());
    final result = await _repository.changeAutomationStatus(id);
    result.fold(
      (err) => emit(ChangeAutomationStatusError(exception: err)),
      (automation) => emit(ChangeAutomationStatusSuccess(
        automations: currentAutomations?.where((e) => e.id != id).toList(),
      )),
    );
  }
}
