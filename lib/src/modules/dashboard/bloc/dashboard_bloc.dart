import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/repositories/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository = sl()..initialize();

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {
      if (event is GetUsageReportEvent) {
        _handleGetUsageReportEvent(event, emit);
      } else if (event is GetDevicesEvent) {
        _handleGetDevicesEvent(event, emit);
      } else if (event is AddDeviceEvent) {
        _handleAddDeviceEvent(event, emit);
      } else if (event is EditDeviceEvent) {
        _handleEditDeviceEvent(event, emit);
      } else if (event is DeleteDeviceEvent) {
        _handleDeleteDeviceEvent(event, emit);
      } else if (event is GetDevicesCategoriesEvent) {
        _handleGetCategoriesEvent(event, emit);
      } else if (event is GetRoomsEvent) {
        _handleGetRoomsEvent(event, emit);
      } else if (event is AddRoomEvent) {
        _handleAddRoomEvent(event, emit);
      } else if (event is DeleteRoomEvent) {
        _handleDeleteRoomEvent(event, emit);
      } else if (event is GetAISuggestionsEvent) {
        _handleGetAISuggestionsEvent(event, emit);
      }
    });
  }
  @override
  Future<void> close() async {
    await _repository.dispose();
    return super.close();
  }

  // Event handlers
  _handleGetUsageReportEvent(
      GetUsageReportEvent event, Emitter<DashboardState> emit) async {
    emit(GetUsageReportLoading());
    _repository.subscribeInReportStream();
    _repository.reportStream.listen((event) {
      emit(GetUsageReportSuccess(event));
    }, onError: (e) => emit(GetUsageReportError(e)));
  }

  // AI SUGGESTIONS
  _handleGetAISuggestionsEvent(
      GetAISuggestionsEvent event, Emitter<DashboardState> emit) async {
    emit(GetAISuggestionsLoading());
    _repository.subscribeInAiSuggestionStream();
    _repository.aiSuggestionStream.listen((event) {
      emit(GetAISuggestionsSuccess(event));
    }, onError: (e) => emit(GetAISuggestionsError(e)));
  }

  // devices events handlers
  _handleGetDevicesEvent(
      GetDevicesEvent event, Emitter<DashboardState> emit) async {
    emit(GetDevicesLoading());
    _repository.subscribeInDevicesStream();
    _repository.devicesStream.listen((event) {
      emit(GetDevicesSuccess(event));
    }, onError: (e) => emit(GetDevicesError(e)));
  }

  _handleAddDeviceEvent(
      AddDeviceEvent event, Emitter<DashboardState> emit) async {
    emit(AddDeviceLoading());
    final result = await _repository.addDevice(event.device);
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
    emit(GetRoomsLoading());
    _repository.subscribeInRoomsStream();
    _repository.roomsStream.listen((event) {
      emit(GetRoomsSuccess(event));
    }, onError: (e) => emit(GetRoomsError(e)));
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
    emit(GetDeviceCategoriesLoading());
    _repository.subscribeInCategoriesStream();
    _repository.categoriesStream.listen((event) {
      emit(GetDeviceCategoriesSuccess(event));
    }, onError: (e) => emit(GetDeviceCategoriesError(e)));
  }
}
