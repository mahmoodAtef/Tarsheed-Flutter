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
  @override
  List<Object?> get props => [];
}

final class GetAISuggestionsLoading extends AISuggestionsState {}

final class GetAISuggestionsSuccess extends AISuggestionsState {}

final class GetAISuggestionsError extends AISuggestionsState {}

// devices
final class DeviceState extends DashboardState {
  const DeviceState();
  @override
  List<Object?> get props => [];
}

final class GetDevicesLoading extends DeviceState {}

final class GetDevicesSuccess extends DeviceState {
  final List<Device> devices;
  const GetDevicesSuccess(this.devices);
  @override
  List<Object?> get props => [devices];
}

final class GetDevicesError extends DeviceState {
  final Exception exception;
  const GetDevicesError(this.exception);
  @override
  List<Object?> get props => [exception];
}

final class AddDeviceLoading extends DeviceState {}

final class AddDeviceSuccess extends DeviceState {
  final Device device;
  const AddDeviceSuccess(this.device);
  @override
  List<Object?> get props => [device];
}

final class AddDeviceError extends DeviceState {
  final Exception exception;
  const AddDeviceError(this.exception);
  @override
  List<Object?> get props => [exception];
}

final class EditDeviceLoading extends DeviceState {}

final class EditDeviceSuccess extends DeviceState {}

final class EditDeviceError extends DeviceState {}

final class DeleteDeviceLoading extends DeviceState {}

final class DeleteDeviceSuccess extends DeviceState {}

final class DeleteDeviceError extends DeviceState {}

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

final class DeleteRoomSuccess extends RoomState {}

final class DeleteRoomError extends RoomState {}

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
