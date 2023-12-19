import 'dart:math';

import 'package:admin_hub_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:hub/theme/colors.dart';

class GeneralOperations {
  static Future<void> copyToClipBoardString(String textToCopy) async {
    await Clipboard.setData(ClipboardData(text: textToCopy));
    Get.showSnackbar(
      GetBar(
        backgroundColor: HubColor.greenLight,
        messageText: Text('Copied to ClipBoard Successfully.',
            style: Get.theme.textTheme.caption?.copyWith(color: Colors.white)),
        isDismissible: true,
        duration: 2.seconds,
        snackPosition: _snackPosition,
      ),
    );
  }

  static String get getPlatformForHeaders {
    if (GetPlatform.isAndroid) {
      return 'android';
    } else if (GetPlatform.isIOS) {
      return 'ios';
    } else {
      return 'web';
    }
  }
}

SnackPosition get _snackPosition {
  return SnackPosition.TOP;
}
