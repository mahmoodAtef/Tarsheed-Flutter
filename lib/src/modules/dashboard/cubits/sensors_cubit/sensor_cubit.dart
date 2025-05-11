import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  SensorCubit() : super(SensorInitial());
}
