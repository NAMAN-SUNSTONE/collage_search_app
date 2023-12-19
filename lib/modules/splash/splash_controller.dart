import 'package:admin_hub_app/base/central_state.dart';
import 'package:admin_hub_app/utils/hub_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/routes/app_pages.dart';

class SplashController extends BaseController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController backgroundAnimationController;

  onAnimationComplete() {
    if (centralState.isUserLoggedIn) {
      centralState.initialiseUser();
      Get.offNamed(Paths.dashboard);
    } else {
      Get.offNamed(Paths.login);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    backgroundAnimationController = AnimationController(vsync: this);
    _setSystemUIMode();
  }

  @override
  void onClose() async {
    super.onClose();
    _resetSystemUIModeToDefault();
  }

  _setSystemUIMode() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  _resetSystemUIModeToDefault() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }
}
