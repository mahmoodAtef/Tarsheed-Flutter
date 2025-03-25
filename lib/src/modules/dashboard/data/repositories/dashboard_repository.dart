import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/services/connectivity_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_local_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_remote_services.dart';

class DashboardRepository implements ConnectivityObserver {
  final DashboardLocalServices _localServices;
  final DashboardRemoteServices _remoteServices;
  final ConnectivityService _connectivityService;
  bool _isConnected = true;

  final StreamController<Report> _reportController =
      StreamController<Report>.broadcast();
  final StreamController<List<DeviceCategory>> _categoriesController =
      StreamController<List<DeviceCategory>>.broadcast();
  late Report _lastReport;
  late int? _lastPeriod;

  Stream<Report> get reportStream => _reportController.stream;

  DashboardRepository(
      this._remoteServices, this._localServices, this._connectivityService);

  void initialize() {
    _connectivityService.addObserver(this);
    _isConnected = _connectivityService.isConnected;
    _localServices.initializeDatabase();
  }

  @override
  Future<void> onConnectivityChanged(bool isConnected) async {
    _isConnected = isConnected;
    if (_isConnected) {
      getUsageReport().then((r) => r.fold((l) {}, (r) {
            if (_lastReport != r) {
              _lastReport = r;
              _reportController.add(r);
              _saveUsageReport(r);
            }
          }));
      getCategories().then((r) => r.fold((l) {}, (r) {
            _categoriesController.add(r);
          }));
    }
  }

  Future<Either<Exception, Report>> getUsageReport({int? period}) async {
    _lastPeriod = period;
    final Either<Exception, Report> result = _isConnected
        ? await _remoteServices.getUsageReport(period: period)
        : await _localServices.getUsageReport(period: period);

    return result;
  }

  Future<Either<Exception, List<DeviceCategory>>> getCategories() async {
    final Either<Exception, List<DeviceCategory>> result = _isConnected
        ? await _remoteServices.getCategories()
        : await _localServices.getCategories();
    return result;
  }

  Future<Either<Exception, List<Sensor>>> getSensors() async {
    final Either<Exception, List<Sensor>> result = _isConnected
        ? await _remoteServices.getSensors()
        : await _localServices.getSensors();
    return result;
  }

  Future<Either<Exception, Unit>> _saveUsageReport(Report report) async {
    return await _localServices.saveUsageReport(report);
  }
}
