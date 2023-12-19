import 'dart:io' show Platform;
import '../constants/constants.dart';

class NativeBridge {
  static NativeBridge? _instance;

  NativeBridge._internal();

  static NativeBridge getInstance() {
    _instance ??= NativeBridge._internal();
    return _instance!;
  }

  static const _platform = MethodChannels.defaultChannel;

  static const _enableBluetooth = "enable_bluetooth";

  static Future enableBluetooth() async {
    if (Platform.isAndroid) {
      return await _platform.invokeMethod(_enableBluetooth);
    }
     return false;
  }
}
