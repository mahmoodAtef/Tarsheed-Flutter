import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'automation_state.dart';

class AutomationCubit extends Cubit<AutomationState> {
  AutomationCubit() : super(AutomationInitial());
}
