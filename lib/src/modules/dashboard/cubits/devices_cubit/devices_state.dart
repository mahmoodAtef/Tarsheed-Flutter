part of 'devices_cubit.dart';

sealed class DevicesState extends Equatable {
  final List<Device>? devices;
  const DevicesState({this.devices});
}

final class DevicesInitial extends DevicesState {
  @override
  List<Object> get props => [];
}

final class GetDevicesLoading extends DevicesState {
  const GetDevicesLoading({super.devices});
  @override
  List<Object?> get props => [];
}

final class GetDevicesSuccess extends DevicesState {
  const GetDevicesSuccess({required super.devices});
  @override
  List<Object?> get props => [devices];
}

final class GetDevicesError extends DevicesState {
  final Exception exception;
  const GetDevicesError(this.exception, {super.devices});
  @override
  List<Object?> get props => [exception];
}

final class AddDeviceLoading extends DevicesState {
  const AddDeviceLoading({super.devices});
  @override
  List<Object?> get props => [];
}

final class AddDeviceSuccess extends DevicesState {
  final Device device;
  const AddDeviceSuccess(this.device, {super.devices});
  @override
  List<Object?> get props => [device];
}

final class AddDeviceError extends DevicesState {
  final Exception exception;
  const AddDeviceError(this.exception, {super.devices});
  @override
  List<Object?> get props => [exception];
}

final class EditDeviceLoading extends DevicesState {
  const EditDeviceLoading({super.devices});
  @override
  List<Object?> get props => [];
}

final class EditDeviceSuccess extends DevicesState {
  const EditDeviceSuccess({super.devices});
  @override
  List<Object?> get props => [];
}

final class EditDeviceError extends DevicesState {
  final Exception exception;
  const EditDeviceError(this.exception, {super.devices});
  @override
  List<Object?> get props => [exception];
}

final class DeleteDeviceLoading extends DevicesState {
  const DeleteDeviceLoading({super.devices});
  @override
  List<Object?> get props => [];
}

final class DeleteDeviceSuccess extends DevicesState {
  final String deviceId;
  const DeleteDeviceSuccess(this.deviceId, {super.devices});
  @override
  List<Object?> get props => [deviceId];
}

final class DeleteDeviceError extends DevicesState {
  final Exception exception;
  const DeleteDeviceError(this.exception, {super.devices});
  @override
  List<Object?> get props => [exception];
}
