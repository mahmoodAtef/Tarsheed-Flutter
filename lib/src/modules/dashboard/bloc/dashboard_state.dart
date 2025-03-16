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
  List<Object?> get props => throw [];
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
  @override
  List<Object?> get props => throw [];
}

final class GetAISuggestionsLoading extends AISuggestionsState {}

final class GetAISuggestionsSuccess extends AISuggestionsState {}

final class GetAISuggestionsError extends AISuggestionsState {}

// devices
final class DeviceState extends DashboardState {
  @override
  List<Object?> get props => throw [];
}

final class GetDevicesLoading extends DeviceState {}

final class GetDevicesSuccess extends DeviceState {}

final class GetDeviceError extends DeviceState {}

final class AddDeviceLoading extends DeviceState {}

final class AddDeviceSuccess extends DeviceState {}

final class AddDeviceError extends DeviceState {}

final class EditDeviceLoading extends DeviceState {}

final class EditDeviceSuccess extends DeviceState {}

final class EditDeviceError extends DeviceState {}

final class DeleteDeviceLoading extends DeviceState {}

final class DeleteDeviceSuccess extends DeviceState {}

final class DeleteDeviceError extends DeviceState {}

// rooms
final class RoomState extends DashboardState {
  @override
  List<Object?> get props => throw [];
}

final class GetRoomsLoading extends RoomState {}

final class GetRoomsSuccess extends RoomState {}

final class GetRoomError extends RoomState {}

final class AddRoomLoading extends RoomState {}

final class AddRoomSuccess extends RoomState {}

final class AddRoomError extends RoomState {}

final class EditRoomLoading extends RoomState {}

final class EditRoomSuccess extends RoomState {}

final class EditRoomError extends RoomState {}

final class DeleteRoomLoading extends RoomState {}

final class DeleteRoomSuccess extends RoomState {}

final class DeleteRoomError extends RoomState {}
