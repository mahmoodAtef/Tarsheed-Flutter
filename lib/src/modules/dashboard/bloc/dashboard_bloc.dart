import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_creation_form.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository = sl()..initialize();
  static DashboardBloc get() => sl();
  List<DeviceCategory> categories = [];
  List<Device> devices = [];
  List<Room> rooms = [];
  List<Sensor> sensors = [];
  Report? report;

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) async {
      if (event is GetUsageReportEvent) {
        await _handleGetUsageReportEvent(event, emit);
      } else if (event is GetDevicesEvent) {
        await _handleGetDevicesEvent(event, emit);
      } else if (event is AddDeviceEvent) {
        await _handleAddDeviceEvent(event, emit);
      } else if (event is EditDeviceEvent) {
        await _handleEditDeviceEvent(event, emit);
      } else if (event is DeleteDeviceEvent) {
        await _handleDeleteDeviceEvent(event, emit);
      } else if (event is GetDevicesCategoriesEvent) {
        await _handleGetCategoriesEvent(event, emit);
      } else if (event is GetRoomsEvent) {
        await _handleGetRoomsEvent(event, emit);
      } else if (event is AddRoomEvent) {
        await _handleAddRoomEvent(event, emit);
      } else if (event is DeleteRoomEvent) {
        await _handleDeleteRoomEvent(event, emit);
      } else if (event is GetAISuggestionsEvent) {
        await _handleGetAISuggestionsEvent(event, emit);
      } else if (event is AddSensorEvent) {
        await _handleAddSensorEvent(event, emit);
      } else if (event is GetSensorsEvent) {
        await _handleGetSensorsEvent(event, emit);
      } else if (event is DeleteSensorEvent) {
        await _handleDeleteSensorEvent(event, emit);
      }
    });
  }

  @override
  Future<void> close() async {
    _deleteAllData();
    await _repository.dispose();
    return super.close();
  }

  void _deleteAllData() {
    devices = [];
    report = null;
    rooms = [];
    sensors = [];
    categories = [];
  }

  // Event handlers
  _handleGetUsageReportEvent(
      GetUsageReportEvent event, Emitter<DashboardState> emit) async {
    if (report == null || event.isRefresh == true) {
      emit(GetUsageReportLoading());
      final result = await _repository.getUsageReport(period: event.period);
      result.fold((l) => emit(GetUsageReportError(l)), (r) {
        report = r;
        emit(GetUsageReportSuccess(r));
      });
    }
  }

  // AI SUGGESTIONS
  _handleGetAISuggestionsEvent(
      GetAISuggestionsEvent event, Emitter<DashboardState> emit) async {
    emit(GetAISuggestionsLoading());
    final result = await _repository.getAISuggestion();
    result.fold((l) => emit(GetAISuggestionsError(l)),
        (r) => emit(GetAISuggestionsSuccess(r)));
  }

  // devices events handlers
  _handleGetDevicesEvent(
      GetDevicesEvent event, Emitter<DashboardState> emit) async {
    if (devices.isEmpty || event.isRefresh == true) {
      emit(GetDevicesLoading());
      final result = await _repository.getDevices();
      result.fold((l) => emit(GetDevicesError(l)), (r) {
        devices = r;
        emit(GetDevicesSuccess(r));
      });
    }
  }

  _handleAddDeviceEvent(
      AddDeviceEvent event, Emitter<DashboardState> emit) async {
    emit(AddDeviceLoading());
    final result = await _repository.addDevice(event.deviceCreationForm);
    result.fold(
        (l) => emit(AddDeviceError(l)), (r) => emit(AddDeviceSuccess(r)));
  }

  _handleEditDeviceEvent(
      EditDeviceEvent event, Emitter<DashboardState> emit) async {
    emit(EditDeviceLoading());
    final result = await _repository.editDevice(
        name: event.name,
        id: event.id,
        description: event.description,
        pinNumber: event.pinNumber);
    result.fold(
        (l) => emit(EditDeviceError(l)), (r) => emit(EditDeviceSuccess()));
  }

  _handleDeleteDeviceEvent(
      DeleteDeviceEvent event, Emitter<DashboardState> emit) async {
    emit(DeleteDeviceLoading());
    final result = await _repository.deleteDevice(event.deviceId);
    result.fold((l) => emit(DeleteDeviceError(l)),
        (r) => emit(DeleteDeviceSuccess(event.deviceId)));
  }

  // rooms events handlers
  _handleGetRoomsEvent(
      GetRoomsEvent event, Emitter<DashboardState> emit) async {
    if (rooms.isEmpty || event.isRefresh == true) {
      emit(GetRoomsLoading());
      final result = await _repository.getRooms();
      result.fold((l) => emit(GetRoomsError(l)), (r) {
        rooms = r;
        emit(GetRoomsSuccess(r));
      });
    }
  }

  _handleAddRoomEvent(AddRoomEvent event, Emitter<DashboardState> emit) async {
    emit(AddRoomLoading());
    final result = await _repository.addRoom(event.room);
    result.fold((l) => emit(AddRoomError(l)), (r) => emit(AddRoomSuccess(r)));
  }

  _handleDeleteRoomEvent(
      DeleteRoomEvent event, Emitter<DashboardState> emit) async {
    emit(DeleteRoomLoading());
    final result = await _repository.deleteRoom(event.roomId);
    result.fold((l) => emit(DeleteRoomError(l)),
        (r) => emit(DeleteRoomSuccess(event.roomId)));
  }

  _handleGetCategoriesEvent(
      GetDevicesCategoriesEvent event, Emitter<DashboardState> emit) async {
    if (categories.isEmpty) {
      emit(GetDeviceCategoriesLoading());
      final result = await _repository.getCategories();
      result.fold((l) => emit(GetDeviceCategoriesError(l)), (r) {
        categories = r;
        debugPrint(categories.toString());
        emit(GetDeviceCategoriesSuccess(r));
      });
    }
  }

  // sensors handlers
  _handleAddSensorEvent(
      AddSensorEvent event, Emitter<DashboardState> emit) async {
    emit(AddSensorLoadingState());
    final result = await _repository.addSensor(event.sensor);
    result.fold((l) => AddSensorErrorState(l), (r) {
      sensors.add(r);
      emit(AddSensorSuccessState(r));
    });
  }

  _handleGetSensorsEvent(
      GetSensorsEvent event, Emitter<DashboardState> emit) async {
    if (sensors.isEmpty || event.isRefresh == true) {
      emit(GetSensorsLoadingState());
      final result = await _repository.getSensors();
      result.fold((l) => GetSensorsErrorState(l), (r) {
        sensors = r;
        emit(GetSensorsSuccessState(r));
      });
    }
  }

  _handleDeleteSensorEvent(
      DeleteSensorEvent event, Emitter<DashboardState> emit) async {
    emit(DeleteSensorLoadingState());
    final result = await _repository.deleteSensor(event.sensorId);
    result.fold((l) => DeleteSensorErrorState(l), (r) {
      sensors.removeWhere((e) => e.id == event.sensorId);
      emit(DeleteSensorSuccessState(event.sensorId));
    });
  }
}
