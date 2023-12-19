import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {

  Rx<Status> status = Status.loading.obs;

  void updateStatus(Status status) {
    this.status.value = status;
  }

  refresh(){
    loading();
    success();
  }
  loading() {
    status.value = Status.loading;
  }

  success() {
    status.value = Status.success;
  }

  failed() {
    status.value = Status.error;
  }

  final int snackBarDuration = 2;
  SnackPosition get _snackPosition {
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      return SnackPosition.TOP;
    } else {
      return SnackPosition.TOP;
    }
  }
  void showSuccessMessage(String message) {
    Get.showSnackbar(
      GetBar(
        icon: Icon(
          Icons.check_circle,
          size: 16,
          color: HubColor.greenExtraDark,
        ),
        backgroundColor: HubColor.greenTint,
        messageText: Text(message,
            style: Get.theme.textTheme.subtitle2?.copyWith(
                color: HubColor.black1E, fontWeight: FontWeight.w400)),
        isDismissible: true,
        duration: snackBarDuration.seconds,
        snackPosition: _snackPosition,
      ),
    );
  }

  void showErrorMessage(String message,
      {String title = "Error", bool isSilent = false}) {
    if (!isSilent) {
      Get.showSnackbar(
        GetBar(
          title: title,
          backgroundColor: HubColor.redLight,
          messageText: Text(message,
              style:
              Get.theme.textTheme.caption?.copyWith(color: Colors.white)),
          isDismissible: true,
          duration: 4.seconds,
          snackPosition: _snackPosition,
        ),
      );
    }
  }
}
