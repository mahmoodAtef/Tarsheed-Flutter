part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

// usage reports
class UsageReportState extends DashboardState {
  const UsageReportState();
  @override
  List<Object?> get props => [];
}

final class GetUsageReportLoading extends UsageReportState {}

final class GetUsageReportSuccess extends UsageReportState {
  final Report report;
  const GetUsageReportSuccess(this.report);

  @override
  List<Object?> get props => [report];
}

final class GetUsageReportError extends UsageReportState {
  final Exception exception;
  const GetUsageReportError(this.exception);
  @override
  List<Object?> get props => [exception];
}

// ai suggestions
class AISuggestionsState extends DashboardState {
  const AISuggestionsState();
  @override
  List<Object?> get props => [];
}

final class GetAISuggestionsLoading extends AISuggestionsState {}

final class GetAISuggestionsSuccess extends AISuggestionsState {
  final String suggestion;
  const GetAISuggestionsSuccess(this.suggestion);
  @override
  List<Object?> get props => [suggestion];
}

final class GetAISuggestionsError extends AISuggestionsState {
  final Exception exception;
  const GetAISuggestionsError(this.exception);
  @override
  List<Object?> get props => [exception];
}

// rooms
final class RoomState extends DashboardState {
  const RoomState();
  @override
  List<Object?> get props => [];
}

final class GetRoomsLoading extends RoomState {}

final class GetRoomsSuccess extends RoomState {
  final List<Room> rooms;
  const GetRoomsSuccess(this.rooms);
  @override
  List<Object?> get props => [rooms];
}

final class GetRoomsError extends RoomState {
  final Exception exception;
  const GetRoomsError(this.exception);
  @override
  List<Object?> get props => [exception];
}

final class AddRoomLoading extends RoomState {}

final class AddRoomSuccess extends RoomState {
  final Room room;
  const AddRoomSuccess(this.room);
  @override
  List<Object?> get props => [room];
}

final class AddRoomError extends RoomState {
  final Exception exception;
  const AddRoomError(this.exception);
  @override
  List<Object?> get props => [exception];
}

final class EditRoomLoading extends RoomState {}

final class EditRoomSuccess extends RoomState {}

final class EditRoomError extends RoomState {}

final class DeleteRoomLoading extends RoomState {}

final class DeleteRoomSuccess extends RoomState {
  final String roomId;
  const DeleteRoomSuccess(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

final class DeleteRoomError extends RoomState {
  final Exception exception;
  const DeleteRoomError(this.exception);
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
