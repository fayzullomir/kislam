import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

  ConnectivityProvider() {
    _initializeConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  bool get isOnline => _isOnline;

  Future<void> _initializeConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result); // List qilib uzatyapmiz
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.any((result) => result != ConnectivityResult.none);
    if (wasOnline != _isOnline) {
      notifyListeners();
    }
  }
}