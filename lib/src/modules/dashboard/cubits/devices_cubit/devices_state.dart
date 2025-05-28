part of 'devices_cubit.dart';

enum DeviceFilterType { consumption, rooms, priority }

enum SortOrder { ascending, descending }

sealed class DevicesState extends Equatable {
  final List<Device>? devices;
  final DeviceFilterType filterType;
  final SortOrder sortOrder;

  const DevicesState({
    this.devices,
    this.filterType = DeviceFilterType.consumption,
    this.sortOrder = SortOrder.descending,
  });
}

final class DevicesInitial extends DevicesState {
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class GetDevicesLoading extends DevicesState {
  final bool? refresh;
  const GetDevicesLoading(
      {super.devices, super.filterType, super.sortOrder, this.refresh});
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class GetDevicesSuccess extends DevicesState {
  const GetDevicesSuccess(
      {required super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class GetDevicesError extends DevicesState {
  final Exception exception;
  const GetDevicesError(this.exception,
      {super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [exception];
}

final class AddDeviceLoading extends DevicesState {
  const AddDeviceLoading({super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class AddDeviceSuccess extends DevicesState {
  final Device device;
  const AddDeviceSuccess(this.device,
      {super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [device, devices, filterType, sortOrder];
}

final class AddDeviceError extends DevicesState {
  final Exception exception;
  const AddDeviceError(this.exception,
      {super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [exception, devices, filterType, sortOrder];
}

final class EditDeviceLoading extends DevicesState {
  const EditDeviceLoading({super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class EditDeviceSuccess extends DevicesState {
  const EditDeviceSuccess({super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class EditDeviceError extends DevicesState {
  final Exception exception;
  const EditDeviceError(this.exception,
      {super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [exception, devices, filterType, sortOrder];
}

final class DeleteDeviceLoading extends DevicesState {
  const DeleteDeviceLoading({super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class DeleteDeviceSuccess extends DevicesState {
  final String deviceId;
  const DeleteDeviceSuccess(this.deviceId,
      {super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [deviceId, devices, filterType, sortOrder];
}

final class DeleteDeviceError extends DevicesState {
  final Exception exception;
  const DeleteDeviceError(this.exception,
      {super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [exception, devices, filterType, sortOrder];
}

final class FilterDevicesState extends DevicesState {
  const FilterDevicesState(
      {super.devices, required super.filterType, required super.sortOrder});
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class ToggleDeviceStatusLoading extends DevicesState {
  final String deviceId;
  const ToggleDeviceStatusLoading(
      {super.devices,
      super.filterType,
      super.sortOrder,
      required this.deviceId});
  @override
  List<Object?> get props => [devices, filterType, sortOrder];
}

final class ToggleDeviceStatusSuccess extends DevicesState {
  final String deviceId;
  const ToggleDeviceStatusSuccess(this.deviceId,
      {super.devices, super.filterType, super.sortOrder});
  @override
  List<Object?> get props => [deviceId, devices, filterType, sortOrder];
}

final class ToggleDeviceStatusError extends DevicesState {
  final Exception exception;
  final String deviceId;
  const ToggleDeviceStatusError(this.exception,
      {super.devices,
      super.filterType,
      super.sortOrder,
      required this.deviceId});
  @override
  List<Object?> get props => [exception, devices, filterType, sortOrder];
}
