part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
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
