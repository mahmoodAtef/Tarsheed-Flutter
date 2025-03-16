import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/services/connectivity_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_local_services.dart';
import 'package:tarsheed/src/modules/dashboard/data/services/dashboard_remote_services.dart';

class DashboardRepository implements ConnectivityObserver {
  final DashboardLocalServices _localServices;
  final DashboardRemoteServices _remoteServices;
  final ConnectivityService _connectivityService;
  bool _isConnected = true;

  final StreamController<Report> _reportController =
      StreamController<Report>.broadcast();
  late Report _lastReport;
  Stream<Report> get reportStream => _reportController.stream;

  DashboardRepository(
      this._remoteServices, this._localServices, this._connectivityService) {
    _connectivityService.addObserver(this);
    _isConnected = _connectivityService.isConnected;
  }

  @override
  Future<void> onConnectivityChanged(bool isConnected) async {
    _isConnected = isConnected;
    if (_isConnected) {
      await getUsageReport().then((r) => r.fold((l) {}, (r) {
            if (_lastReport != r) {
              _lastReport = r;
              _reportController.add(r);
            }
          }));
    }
  }

  Future<Either<Exception, Report>> getUsageReport() async {
    final Either<Exception, Report> result = _isConnected
        ? await _remoteServices.getUsageReport()
        : await _localServices.getUsageReport();
    return result;
  }
}
