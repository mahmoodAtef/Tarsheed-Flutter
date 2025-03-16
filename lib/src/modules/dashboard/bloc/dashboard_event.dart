part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

/// usage
final class GetUsageReportEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
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
  @override
  List<Object?> get props => [];
}

final class AddRoomEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

final class UpdateRoomEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

final class DeleteRoomEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

// devices
final class GetDevicesEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

final class AddDeviceEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

final class UpdateDeviceEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

final class DeleteDeviceEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

// devices categories
final class GetDevicesCategoriesEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}
