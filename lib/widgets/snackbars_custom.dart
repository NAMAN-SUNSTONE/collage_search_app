import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/throttle_debounce.dart';
// import 'package:hub/widgets/reusables.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

import '../theme/app_colors.dart';
import '../theme/colors.dart';
import '../utils/throttle_debounce.dart';

// import '../utils/app_colors.dart';

abstract class SnackBarMessages {
  ///in seconds
  static const int timeoutTime = 3;
  static final Duration timeoutDuration = timeoutTime.seconds;

  static Throttle throttle = Throttle(timeoutDuration);

  static void showErrorMessage(String message,
      {bool isErrorMandate = false, String title = "Error"}) {
    throttle.call(() => Get.rawSnackbar(
          messageText: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: HubColor.white,
              ),
              SpaceHorizontal(
                factor: 1,
              ),
              Flexible(
                child: Text(
                  message,
                  style: UIKitDefaultTypography().bodyText2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
            ],
          ),
          maxWidth: 600,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 16,
          backgroundColor: HubColor.black.withOpacity(0.7),
          isDismissible: true,
        ));
  }

  static void showTopMessage(
      {required String msg,
      VoidCallback? onViewTap,
      int secondToView = timeoutTime}) {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(0),
        messageText: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: onViewTap != null ? 5 : 18),
          decoration: const BoxDecoration(
              color: BaseAppColor.green2,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6))),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                size: 16,
                color: BaseAppColor.greenIntense,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(msg,
                    style: Get.theme.textTheme.bodyText2
                        ?.copyWith(color: BaseAppColor.grey1)),
                flex: 1,
              ),
              if (onViewTap != null)
                TextButton(
                  onPressed: onViewTap,
                  child: Text('View',
                      style: Get.context?.textTheme.headline2?.copyWith(
                          fontSize: 12, color: BaseAppColor.greenIntense)),
                )
            ],
          ),
        ),
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: secondToView),
      ),
    );
  }
}
