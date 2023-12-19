import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityManager {

  static RxBool isConnected = false.obs;

  static bool? lastConnectedStatus;

  static Future<bool> isOnline() async {
    if (lastConnectedStatus != null) return lastConnectedStatus!;

    bool hasConnection = await _checkConnection();
    if (!hasConnection) {
      lastConnectedStatus = false;
      return lastConnectedStatus!;
    }

    lastConnectedStatus = await _checkNetwork();
    isConnected.value = lastConnectedStatus!;
    return lastConnectedStatus!;
  }

  static Future<bool> _checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  static Future<bool> _checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
