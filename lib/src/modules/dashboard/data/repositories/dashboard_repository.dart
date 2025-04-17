import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/services/connectivity_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_local_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_remote_services.dart';

class DashboardRepository implements ConnectivityObserver {
  final DashboardLocalServices _localServices;
  final DashboardRemoteServices _remoteServices;
  final ConnectivityService _connectivityService;

  bool _isConnected = true;
  void initialize() {
    // initialize the connectivity service and listen for changes in connectivity
    _connectivityService.addObserver(this);
    _isConnected = _connectivityService.isConnected;
    _localServices.initializeDatabase();
  }

  Future<void> dispose() async {
    _connectivityService.removeObserver(this);
    Future.wait([
      _reportStreamController.close(),
      _devicesStreamController.close(),
      _categoriesStreamController.close(),
      _roomsStreamController.close(),
      _sensorsStreamController.close(),
    ]);
  }

  @override
  void onConnectivityChanged(bool isConnected) {
    _isConnected = isConnected;
    if (_isConnected) {
      // update subscribed streams if connected
      if (_subscribedToReportStream) _updateReport();
      if (_subscribedToDevicesStream) _updateDevices();
      if (_subscribedToCategoriesStream) _updateCategories();
      if (_subscribedToRoomsStream) _updateRooms();
      if (_subscribedToSensorsStream) _updateSensors();
    }
  }

  DashboardRepository(
      this._remoteServices, this._localServices, this._connectivityService);

  // report logic
  late Report
      _lastReport; // to be used when comparing new report before adding it to the stream
  int? _lastReportPeriod;
  bool _subscribedToReportStream = false;
  String? _lastAiSuggestion;
  final StreamController<Report> _reportStreamController = StreamController();
  Stream<Report> get reportStream => _reportStreamController.stream;

  void subscribeInReportStream() {
    _subscribedToReportStream = true;
    _updateReport();
  }

  _updateReport() {
    _getUsageReport(period: _lastReportPeriod).then((r) => r.fold((l) {
          _reportStreamController.sink.addError(l);
        }, (r) {
          if (_lastReport != r) {
            _reportStreamController.sink.add(r);
            _saveUsageReport(r);
          }
        }));
  }

  Future<Either<Exception, Report>> _getUsageReport({int? period}) async {
    _lastReportPeriod = period;
    final Either<Exception, Report> result = _isConnected
        ? await _remoteServices.getUsageReport(period: period)
        : await _localServices.getUsageReport(period: period);

    return result;
  }

  Future<Either<Exception, Unit>> _saveUsageReport(Report report) async {
    _lastReport = report;
    return await _localServices.saveUsageReport(report);
  }

  // Ai suggestions Logic
  final StreamController<String> _aiSuggestionStreamController =
      StreamController();
  Stream<String> get aiSuggestionStream => _aiSuggestionStreamController.stream;

  void subscribeInAiSuggestionStream() {
    _subscribedToReportStream = true;
    _updateAiSuggestion();
  }

  _updateAiSuggestion() {
    _getAiSuggestion().then((r) => r.fold((l) {
          _aiSuggestionStreamController.sink.addError(l);
        }, (r) {
          if (_lastAiSuggestion != r) {
            _saveAiSuggestion(r);
            _aiSuggestionStreamController.sink.add(r);
          }
        }));
  }

  Future<Either<Exception, String>> _getAiSuggestion() async {
    final Either<Exception, String> result = _isConnected
        ? await _remoteServices.getAISuggestions()
        : await _localServices.getAISuggestions();
    return result;
  }

  Future<Either<Exception, Unit>> _saveAiSuggestion(String suggestion) async {
    _lastAiSuggestion = suggestion;
    return await _localServices.saveAISuggestions(suggestion);
  }

  // devices logic
  late List<Device> _lastDevices;
  final StreamController<List<Device>> _devicesStreamController =
      StreamController<List<Device>>();
  bool _subscribedToDevicesStream = false;

  Stream<List<Device>> get devicesStream => _devicesStreamController.stream;

  void subscribeInDevicesStream() {
    _subscribedToDevicesStream = true;
    _updateDevices();
  }

  _updateDevices() {
    _getDevices().then((r) => r.fold((l) {
          _devicesStreamController.sink.addError(l);
        }, (r) {
          if (_lastDevices != r) {
            _saveDevices(r);
            _devicesStreamController.sink.add(r);
          }
        }));
  }

  Future<Either<Exception, List<Device>>> _getDevices() async {
    final Either<Exception, List<Device>> result = _isConnected
        ? await _remoteServices.getDevices()
        : await _localServices.getDevices();
    return result;
  }

  Future<Either<Exception, Device>> addDevice(Device device) async {
    var result = await _remoteServices.addDevice(device);
    result.fold((l) => null, (r) {
      _lastDevices.add(r);
      _saveDevices(_lastDevices);
    });
    return result;
  }

  _saveDevices(List<Device> devices) async {
    _lastDevices = devices;
    return await _localServices.saveDevices(devices);
  }

  // Devices categories logic
  late List<DeviceCategory> _lastCategories;
  final StreamController<List<DeviceCategory>> _categoriesStreamController =
      StreamController<List<DeviceCategory>>();
  bool _subscribedToCategoriesStream = false;

  Stream<List<DeviceCategory>> get categoriesStream =>
      _categoriesStreamController.stream;

  void subscribeInCategoriesStream() {
    _subscribedToCategoriesStream = true;
    _updateCategories();
  }

  _updateCategories() {
    _getCategories().then((r) => r.fold((l) {
          _categoriesStreamController.sink.addError(l);
        }, (r) {
          if (_lastCategories != r) {
            _saveCategories(r);
            _categoriesStreamController.sink.add(r);
          }
        }));
  }

  Future<Either<Exception, List<DeviceCategory>>> _getCategories() async {
    final Either<Exception, List<DeviceCategory>> result = _isConnected
        ? await _remoteServices.getCategories()
        : await _localServices.getCategories();
    return result;
  }

  _saveCategories(List<DeviceCategory> categories) async {
    _lastCategories = categories;
    return await _localServices.saveCategories(categories);
  }

  // Rooms logic

  late List<Room> _lastRooms;
  final StreamController<List<Room>> _roomsStreamController =
      StreamController<List<Room>>();
  bool _subscribedToRoomsStream = false;

  Stream<List<Room>> get roomsStream => _roomsStreamController.stream;

  void subscribeInRoomsStream() {
    _subscribedToRoomsStream = true;
    _updateRooms();
  }

  _updateRooms() {
    _getRooms().then((r) => r.fold((l) {
          _roomsStreamController.sink.addError(l);
        }, (r) {
          if (_lastRooms != r) {
            _saveRooms(r);
            _roomsStreamController.sink.add(r);
          }
        }));
  }

  Future<Either<Exception, List<Room>>> _getRooms() async {
    final Either<Exception, List<Room>> result = _isConnected
        ? await _remoteServices.getRooms()
        : await _localServices.getRooms();
    return result;
  }

  Future<Either<Exception, Room>> addRoom(Room room) async {
    var result = await _remoteServices.addRoom(room);
    result.fold((l) => null, (r) {
      _lastRooms.add(r);
      _saveRooms(_lastRooms);
    });
    return result;
  }

  _saveRooms(List<Room> rooms) async {
    _lastRooms = rooms;
    return await _localServices.saveRooms(rooms);
  }

  // Sensors logic

  late List<Sensor> _lastSensors;
  final StreamController<List<Sensor>> _sensorsStreamController =
      StreamController<List<Sensor>>();
  bool _subscribedToSensorsStream = false;

  Stream<List<Sensor>> get sensorsStream => _sensorsStreamController.stream;

  void subscribeInSensorsStream() {
    _subscribedToSensorsStream = true;
    _updateSensors();
  }

  _updateSensors() {
    _getSensors().then((r) => r.fold((l) {
          _sensorsStreamController.sink.addError(l);
        }, (r) {
          if (_lastSensors != r) {
            _saveSensors(r);
            _sensorsStreamController.sink.add(r);
          }
        }));
  }

  Future<Either<Exception, List<Sensor>>> _getSensors() async {
    final Either<Exception, List<Sensor>> result = _isConnected
        ? await _remoteServices.getSensors()
        : await _localServices.getSensors();
    return result;
  }

  Future<Either<Exception, Sensor>> addSensor(Sensor sensor) async {
    var result = await _remoteServices.addSensor(sensor);
    result.fold((l) => null, (r) {
      _lastSensors.add(r);
      _saveSensors(_lastSensors);
    });
    return result;
  }

  _saveSensors(List<Sensor> sensors) async {
    _lastSensors = sensors;
    return await _localServices.saveSensors(sensors);
  }
}
