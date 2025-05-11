import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final List<ConnectivityObserver> _observers = [];

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void addObserver(ConnectivityObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  void removeObserver(ConnectivityObserver observer) {
    _observers.remove(observer);
  }

  void _notifyObservers() {
    for (var observer in _observers) {
      observer.onConnectivityChanged(_isConnected);
    }
  }

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
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _notifyObservers();
    }
  }
}

abstract class ConnectivityObserver {
  void onConnectivityChanged(bool isConnected);
}
