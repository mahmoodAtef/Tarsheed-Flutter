import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/automation/data/models/automation.dart';
import 'package:tarsheed/src/modules/automation/data/repositories/repository.dart';

part 'automation_state.dart';

class AutomationCubit extends Cubit<AutomationState> {
  AutomationCubit() : super(AutomationInitial());
  static AutomationCubit get() {
    if (sl<AutomationCubit>().isClosed) {
      sl.unregister<AutomationCubit>();
      sl.registerLazySingleton<AutomationCubit>(() => AutomationCubit());
    } else if (!sl.isRegistered<AutomationCubit>()) {
      sl.registerLazySingleton<AutomationCubit>(() => AutomationCubit());
    }
    return sl<AutomationCubit>();
  }

  final _repository = sl<AutomationRepository>();
  Future<void> getAllAutomations() async {
    List<Automation>? currentAutomations = state.automations;
    emit(GetAllAutomationsLoading(automations: currentAutomations));
    final result = await _repository.getAutomations();
    debugPrint('getAllAutomations result: $result');
    result.fold(
      (err) => emit(GetAllAutomationsError(
        exception: err,
        automations: currentAutomations,
      )),
      (automations) => emit(GetAllAutomationsSuccess(automations: automations)),
    );
  }

  Future<void> addAutomation(Automation automation) async {
    List<Automation>? currentAutomations = state.automations;
    emit(AddAutomationLoading(
      automations: currentAutomations,
    ));
    final result = await _repository.addAutomation(automation);
    result.fold(
      (err) => emit(
        AddAutomationError(exception: err, automations: currentAutomations),
      ),
      (automation) => emit(AddAutomationSuccess(
        automations: [automation] + (currentAutomations ?? []),
      )),
    );
  }

  Future<void> updateAutomation(Automation automation) async {
    List<Automation>? currentAutomations = state.automations;
    emit(UpdateAutomationLoading(automations: currentAutomations));
    final result = await _repository.updateAutomation(automation);
    result.fold(
      (err) => emit(UpdateAutomationError(
          exception: err, automations: currentAutomations)),
      (automation) => emit(UpdateAutomationSuccess(
        automations: [automation] + (currentAutomations ?? []),
      )),
    );
  }

  Future<void> deleteAutomation(String id) async {
    List<Automation>? currentAutomations = state.automations;
    emit(DeleteAutomationLoading(
      automations: currentAutomations?.where((e) => e.id != id).toList(),
    ));
    final result = await _repository.deleteAutomation(id);
    result.fold(
      (err) => emit(DeleteAutomationError(
          exception: err, automations: currentAutomations)),
      (automation) => emit(DeleteAutomationSuccess(
        automations: currentAutomations?.where((e) => e.id != id).toList(),
      )),
    );
  }

  Future<void> changeAutomationStatus(String id) async {
    List<Automation>? currentAutomations = state.automations;
    emit(ChangeAutomationStatusLoading(
      automations: currentAutomations,
    ));
    final result = await _repository.changeAutomationStatus(id);
    result.fold(
      (err) => emit(ChangeAutomationStatusError(
        exception: err,
        automations: currentAutomations,
      )),
      (updatedAutomation) {
        final updatedList = currentAutomations?.map((automation) {
              if (automation.id == id) {
                return automation.copyWith(isEnabled: !automation.isEnabled);
              }
              return automation;
            }).toList() ??
            [];

        emit(ChangeAutomationStatusSuccess(automations: updatedList));
      },
    );
  }
}
