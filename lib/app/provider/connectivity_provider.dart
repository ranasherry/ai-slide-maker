import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    log("ConnectivityProvider initialized");
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      _isConnected = results.any((result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi);

      log("ConnectivityResult: ${results}");
      log("IsConnected: ${_isConnected}");
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
