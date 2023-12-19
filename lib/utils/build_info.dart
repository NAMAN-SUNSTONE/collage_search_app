import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BuildInfo {
  static String buildVersion = '';
  static String buildNumber = '';
  static String deviceModel = '';
  static Size screenSize = const Size(100, 200);

  static String osVersion = Platform.operatingSystemVersion;
  static String get platform => _getPlatform();

  static Future init() async {
    final info = await PackageInfo.fromPlatform();
    buildVersion = info.version;
    buildNumber = info.buildNumber;
    screenSize =
        MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size;

    String platform = _getPlatform();
    if (platform == "android" || platform == "ios") {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (platform == "android") {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        deviceModel = androidInfo.model ?? '';
      } else if (platform == "ios") {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.utsname.machine ?? '';
      }
    } else {
// In Case of WEB
      deviceModel = "System";
    }
  }

  static String _getPlatform() {
    if (GetPlatform.isAndroid) {
      return 'android';
    } else if (GetPlatform.isIOS) {
      return 'ios';
    } else {
      return 'web';
    }
  }
}
