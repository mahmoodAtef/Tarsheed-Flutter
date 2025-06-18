import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository = sl()..initialize();
  static DashboardBloc get() {
    // check if the bloc is already registered and not closed
    if (sl<DashboardBloc>().isClosed) {
      sl.unregister<DashboardBloc>();
      sl.registerLazySingleton<DashboardBloc>(
        () => DashboardBloc(),
      );
    }

    return sl<DashboardBloc>();
  }

  @override
  close() async {
    _repository.clearData();
    sensors = [];
    // return super.close();
  }

  List<Sensor> sensors = [];

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
      } else if (event is GetPaymentUrlEvent) {
        await _handleGetPaymentUrlEvent(event, emit);
      }
    });
  }

  Future<void> closeBloc() async {
    _deleteAllData();
    await _repository.dispose();
    return super.close();
  }

  void _deleteAllData() {
    sensors = [];
  }

  // rooms events handlers
  _handleGetRoomsEvent(
      GetRoomsEvent event, Emitter<DashboardState> emit) async {
    final List<Room> currentRooms = state.rooms ?? [];

    emit(GetRoomsLoading(
      rooms: currentRooms,
    ));
    final result = await _repository.getRooms(
      forceRefresh: event.isRefresh ?? false,
    );
    debugPrint(
        'result rooms: ${result.isRight() ? result.getOrElse(() => []).length : 'error'}');

    result.fold((l) => emit(GetRoomsError(l, rooms: currentRooms)), (r) {
      emit(GetRoomsSuccess(rooms: r));
    });
    debugPrint('${state.rooms}');
  }

  _handleAddRoomEvent(AddRoomEvent event, Emitter<DashboardState> emit) async {
    final List<Room> currentRooms = state.rooms ?? [];

    emit(AddRoomLoading(
      rooms: currentRooms,
    ));
    final result = await _repository.addRoom(event.room);
    result.fold(
        (l) => emit(AddRoomError(l, rooms: currentRooms)),
        (r) => emit(AddRoomSuccess(
              r,
              rooms: [...currentRooms],
            )));
  }

  _handleDeleteRoomEvent(
      DeleteRoomEvent event, Emitter<DashboardState> emit) async {
    final List<Room> currentRooms = state.rooms ?? [];
    emit(DeleteRoomLoading(
      rooms: currentRooms,
    ));
    final result = await _repository.deleteRoom(event.roomId);
    result.fold(
        (l) => emit(DeleteRoomError(l, rooms: currentRooms)),
        (r) => emit(DeleteRoomSuccess(event.roomId,
            rooms: (state.rooms ?? <Room>[])
                .where((room) => room.id != event.roomId)
                .toList())));
  }

  _handleGetCategoriesEvent(
      GetDevicesCategoriesEvent event, Emitter<DashboardState> emit) async {
    emit(GetDeviceCategoriesLoading());
    final result = await _repository.getCategories();
    result.fold((l) => emit(GetDeviceCategoriesError(l)), (r) {
      emit(GetDeviceCategoriesSuccess(r));
    });
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

  _handleGetPaymentUrlEvent(
      GetPaymentUrlEvent event, Emitter<DashboardState> emit) async {
    emit(GetPaymentUrlLoadingState());
    final result = await _repository.getPaymentUrl();
    result.fold((l) => GetPaymentUrlErrorState(l), (r) {
      emit(GetPaymentUrlSuccessState(r));
    });
  }
}
