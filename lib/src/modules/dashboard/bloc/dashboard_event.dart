part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

/// usage
final class GetUsageReportEvent extends DashboardEvent {
  final String? period;
  final bool? isRefresh;
  const GetUsageReportEvent({this.period, this.isRefresh});
  @override
  List<Object?> get props => [period];
}

final class UpdateUsageReportEvent extends DashboardEvent {
  final Report usageReport;
  const UpdateUsageReportEvent({required this.usageReport});
  @override
  List<Object?> get props => [usageReport];
}

final class GetAISuggestionsEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

// rooms
final class GetRoomsEvent extends DashboardEvent {
  final bool? isRefresh;
  const GetRoomsEvent({this.isRefresh});
  @override
  List<Object?> get props => [isRefresh];
}

final class AddRoomEvent extends DashboardEvent {
  final Room room;
  const AddRoomEvent(this.room);

  @override
  List<Object?> get props => [room];
}

final class UpdateRoomEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

final class DeleteRoomEvent extends DashboardEvent {
  final String roomId;
  const DeleteRoomEvent(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

// devices
final class GetDevicesEvent extends DashboardEvent {
  final bool? isRefresh;
  const GetDevicesEvent({this.isRefresh});
  @override
  List<Object?> get props => [];
}

final class AddDeviceEvent extends DashboardEvent {
  final DeviceCreationForm deviceCreationForm;
  const AddDeviceEvent(this.deviceCreationForm);
  @override
  List<Object?> get props => [deviceCreationForm];
}

final class EditDeviceEvent extends DashboardEvent {
  final String id;
  final String? name;
  final String? description;
  final String? pinNumber;

  const EditDeviceEvent(
      {required this.id, this.name, this.description, this.pinNumber});

  @override
  List<Object?> get props => [id, name, description, pinNumber];
}

final class DeleteDeviceEvent extends DashboardEvent {
  final String deviceId;
  const DeleteDeviceEvent(this.deviceId);
  @override
  List<Object?> get props => [deviceId];
}

// devices categories
final class GetDevicesCategoriesEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

final class AddSensorEvent extends DashboardEvent {
  final Sensor sensor;
  const AddSensorEvent(this.sensor);
  @override
  List<Object?> get props => [sensor];
}

final class EditSensorEvent extends DashboardEvent {
  final String id;
  final String? name;
  final String? description;
  final String? pinNumber;

  const EditSensorEvent(
      {required this.id, this.name, this.description, this.pinNumber});

  @override
  List<Object?> get props => [id, name, description, pinNumber];
}

final class DeleteSensorEvent extends DashboardEvent {
  final String sensorId;
  const DeleteSensorEvent(this.sensorId);
  @override
  List<Object?> get props => [sensorId];
}

final class GetSensorsEvent extends DashboardEvent {
  final bool? isRefresh;
  const GetSensorsEvent({this.isRefresh});
  @override
  List<Object?> get props => [isRefresh];
}
