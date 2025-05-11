part of 'sensor_cubit.dart';

sealed class SensorState extends Equatable {
  const SensorState();
}

final class SensorInitial extends SensorState {
  @override
  List<Object> get props => [];
}
