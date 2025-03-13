import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void initialize() {
    _checkConnectivity();
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _handleConnectivityResults(results);
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityResults(results);
    } catch (e) {
      _updateConnectionStatus(false);
    }
  }

  void _handleConnectivityResults(List<ConnectivityResult> results) {
    bool hasConnection = results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile);
    _updateConnectionStatus(hasConnection);
  }

  void _updateConnectionStatus(bool isConnected) {
    _isConnected = isConnected;
    _connectionStatusController.add(_isConnected);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
