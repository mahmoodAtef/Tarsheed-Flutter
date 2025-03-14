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

  final StreamController<Either<Exception, Report>> _reportController =
      StreamController<Either<Exception, Report>>.broadcast();

  DashboardRepository(
      this._remoteServices, this._localServices, this._connectivityService) {
    _connectivityService.addObserver(this);
    _isConnected = _connectivityService.isConnected;
  }

  @override
  void onConnectivityChanged(bool isConnected) {
    _isConnected = isConnected;
    if (_isConnected) {}
  }

  Future<Either<Exception, Report>> getUsageReport() async {
    final Either<Exception, Report> result = _isConnected
        ? await _remoteServices.getUsageReport()
        : await _localServices.getUsageReport();
    return result;
  }
}
