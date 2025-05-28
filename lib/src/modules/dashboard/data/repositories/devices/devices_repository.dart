import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_creation_form.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/devices/devices_remote_services.dart';

class DevicesRepository {
  final DevicesRemoteServices _remote;
  // final DeviceLocalServices _local;

  DevicesRepository(
    this._remote,
  );

  Future<void> initialize() async {
    // await _local.initializeDatabase();
  }

  Future<void> dispose() async {
    // TODO: use it after reusing offline first
  }

  Future<Either<Exception, List<Device>>> getDevices() {
    return _remote.getDevices();
  }

  Future<Either<Exception, Device>> addDevice(DeviceCreationForm dto) {
    return _remote.addDevice(dto);
  }

  Future<Either<Exception, Unit>> editDevice({
    required String id,
    String? name,
    String? description,
    String? pinNumber,
  }) {
    return _remote.editDevice(
      id: id,
      name: name,
      description: description,
      pinNumber: pinNumber,
    );
  }

  Future<Either<Exception, Unit>> deleteDevice(String id) {
    return _remote.deleteDevice(id);
  }

  Future<Either<Exception, Unit>> toggleDeviceStatus(String id) {
    return _remote.toggleDeviceStatus(id);
  }
}
