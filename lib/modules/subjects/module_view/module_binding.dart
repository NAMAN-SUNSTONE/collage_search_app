import 'package:get/get.dart';

import 'module_controller.dart';
// import 'package:hub/academic_content/module_view/module_controller.dart';
// import 'package:hub/student_onboarding/onboarding_detail/student_onboarding_controller.dart';

class ModuleViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleController>(() => ModuleController(), fenix: true);
  }
}
