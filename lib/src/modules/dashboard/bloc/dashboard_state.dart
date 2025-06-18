part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  final List<Room>? rooms;
  const DashboardState({this.rooms});
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

// usage reports

// rooms
final class RoomState extends DashboardState {
  const RoomState({super.rooms});
  @override
  List<Object?> get props => [rooms];
}

final class GetRoomsLoading extends RoomState {
  const GetRoomsLoading({super.rooms});
  @override
  List<Object?> get props => [];
}

final class GetRoomsSuccess extends RoomState {
  const GetRoomsSuccess({required super.rooms});
  @override
  List<Object?> get props => [rooms];
}

final class GetRoomsError extends RoomState {
  final Exception exception;
  const GetRoomsError(this.exception, {super.rooms});
  @override
  List<Object?> get props => [exception];
}

final class AddRoomLoading extends RoomState {
  const AddRoomLoading({super.rooms});
  @override
  List<Object?> get props => [];
}

final class AddRoomSuccess extends RoomState {
  final Room room;
  const AddRoomSuccess(this.room, {super.rooms});
  @override
  List<Object?> get props => [room];
}

final class AddRoomError extends RoomState {
  final Exception exception;
  const AddRoomError(this.exception, {super.rooms});
  @override
  List<Object?> get props => [exception];
}

final class EditRoomLoading extends RoomState {
  const EditRoomLoading({super.rooms});
  @override
  List<Object?> get props => [];
}

final class EditRoomSuccess extends RoomState {
  final Room room;
  const EditRoomSuccess(this.room);
  @override
  List<Object?> get props => [room];
}

final class EditRoomError extends RoomState {
  final Exception exception;
  const EditRoomError(this.exception, {super.rooms});
  @override
  List<Object?> get props => [exception];
}

final class DeleteRoomLoading extends RoomState {
  const DeleteRoomLoading({super.rooms});
  @override
  List<Object?> get props => [];
}

final class DeleteRoomSuccess extends RoomState {
  final String roomId;
  const DeleteRoomSuccess(this.roomId, {super.rooms});
  @override
  List<Object?> get props => [roomId];
}

final class DeleteRoomError extends RoomState {
  final Exception exception;
  const DeleteRoomError(this.exception, {super.rooms});
  @override
  List<Object?> get props => [exception];
}

// device categories
final class DeviceCategoryState extends DashboardState {
  const DeviceCategoryState();
  @override
  List<Object?> get props => [];
}

final class GetDeviceCategoriesLoading extends DeviceCategoryState {}

final class GetDeviceCategoriesSuccess extends DeviceCategoryState {
  final List<DeviceCategory> deviceCategories;
  const GetDeviceCategoriesSuccess(this.deviceCategories);
  @override
  List<Object?> get props => [deviceCategories];
}

final class GetDeviceCategoriesError extends DeviceCategoryState {
  final Exception exception;
  const GetDeviceCategoriesError(this.exception);
  @override
  List<Object?> get props => [exception];
}

final class SensorState extends DashboardState {
  const SensorState();
  @override
  List<Object?> get props => [];
}

final class AddSensorLoadingState extends SensorState {}

final class AddSensorSuccessState extends SensorState {
  final Sensor sensor;
  const AddSensorSuccessState(this.sensor);
  @override
  List<Object?> get props => [sensor];
}

final class AddSensorErrorState extends SensorState {
  final Exception exception;
  const AddSensorErrorState(this.exception);

  @override
  List<Object?> get props => [exception];
}

final class DeleteSensorLoadingState extends SensorState {}

final class DeleteSensorSuccessState extends SensorState {
  final String sensorId;
  const DeleteSensorSuccessState(this.sensorId);
  @override
  List<Object?> get props => [sensorId];
}

final class DeleteSensorErrorState extends SensorState {
  final Exception exception;
  const DeleteSensorErrorState(this.exception);

  @override
  List<Object?> get props => [exception];
}

final class GetSensorsLoadingState extends SensorState {}

final class GetSensorsSuccessState extends SensorState {
  final List<Sensor> sensors;
  const GetSensorsSuccessState(this.sensors);
  @override
  List<Object?> get props => [sensors];
}

final class GetSensorsErrorState extends SensorState {
  final Exception exception;
  const GetSensorsErrorState(this.exception);

  @override
  List<Object?> get props => [exception];
}

/// Payment URL state

final class GetPaymentUrlState extends DashboardState {
  const GetPaymentUrlState({super.rooms});
  @override
  List<Object?> get props => [];
}

final class GetPaymentUrlLoadingState extends GetPaymentUrlState {}

final class GetPaymentUrlSuccessState extends GetPaymentUrlState {
  final String paymentUrl;
  const GetPaymentUrlSuccessState(this.paymentUrl);
  @override
  List<Object?> get props => [paymentUrl];
}

final class GetPaymentUrlErrorState extends GetPaymentUrlState {
  final Exception exception;
  const GetPaymentUrlErrorState(this.exception);
  @override
  List<Object?> get props => [exception];
}
