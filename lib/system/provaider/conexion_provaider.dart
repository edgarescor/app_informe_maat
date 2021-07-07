import 'dart:async';

import 'package:connectivity/connectivity.dart';

class VerificadorConexion {
  static final VerificadorConexion conexion = new VerificadorConexion._();
  VerificadorConexion._();

  String connectionStatus = 'Unknown';
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.

    result = await connectivity.checkConnectivity();

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        connectionStatus = "1";
        break;
      default:
        connectionStatus = "0";
        break;
    }
  }
}
