import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_creation_form.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/devices/devices_repository.dart';

part 'devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit() : super(DevicesInitial());

  final _repository = sl<DevicesRepository>();
  Future<void> addDevice(DeviceCreationForm form) async {
    final current = state.devices ?? <Device>[];
    emit(AddDeviceLoading(devices: current));

    final result = await _repository.addDevice(form);
    result.fold(
      (err) => emit(AddDeviceError(err, devices: current)),
      (newDevice) {
        final updated = List<Device>.from(current)..add(newDevice);
        emit(AddDeviceSuccess(newDevice, devices: updated));
      },
    );
  }

  Future<void> editDevice({
    required String id,
    String? name,
    String? description,
    String? pinNumber,
  }) async {
    final current = state.devices ?? <Device>[];
    emit(EditDeviceLoading(devices: current));

    final result = await _repository.editDevice(
      id: id,
      name: name,
      description: description,
      pinNumber: pinNumber,
    );

    result.fold(
      (err) => emit(EditDeviceError(err, devices: current)),
      (_) {
        final updated = current.map((d) {
          return d.id == id
              ? d.copyWith(
                  name: name ?? d.name,
                  description: description ?? d.description,
                  pinNumber: pinNumber ?? d.pinNumber,
                )
              : d;
        }).toList();
        emit(EditDeviceSuccess(devices: updated));
      },
    );
  }

  Future<void> deleteDevice(String id) async {
    final current = state.devices ?? <Device>[];
    emit(DeleteDeviceLoading(devices: current));

    final result = await _repository.deleteDevice(id);
    result.fold(
      (err) => emit(DeleteDeviceError(err, devices: current)),
      (_) {
        final updated = current.where((d) => d.id != id).toList();
        emit(DeleteDeviceSuccess(id, devices: updated));
      },
    );
  }
}
