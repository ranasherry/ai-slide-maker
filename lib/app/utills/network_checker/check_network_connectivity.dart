import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkNetworkConnectivity() async {
  try {
    bool isConnected = await InternetConnectionChecker.instance.hasConnection
        .timeout(Duration(seconds: 5), onTimeout: () => false);

    if (isConnected) {
      print('Device is connected to the internet');
      return true;
    } else {
      print('Device is not connected to the internet');
      return false;
    }
  } catch (e) {
    print('Error checking internet connection: $e');
    return false;
  }
}
