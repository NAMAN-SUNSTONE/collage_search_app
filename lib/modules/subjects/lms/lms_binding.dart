import 'package:get/get.dart';

import 'lms_controller.dart';
// import 'package:hub/academic_content/lms/lms_controller.dart';

class LmsBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<LmsController>()) {
      Get.delete<LmsController>();
    }
    Get.lazyPut<LmsController>(() => LmsController());
  }
}