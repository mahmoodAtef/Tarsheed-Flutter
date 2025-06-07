import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
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
      if (event is GetDevicesCategoriesEvent) {
        await _handleGetCategoriesEvent(event, emit);
      } else if (event is GetRoomsEvent) {
        await _handleGetRoomsEvent(event, emit);
      } else if (event is AddRoomEvent) {
        await _handleAddRoomEvent(event, emit);
      } else if (event is DeleteRoomEvent) {
        await _handleDeleteRoomEvent(event, emit);
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
    } else {
      emit(GetRoomsSuccess(rooms));
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
    } else {
      emit(GetDeviceCategoriesSuccess(categories));
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
