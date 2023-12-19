import 'package:admin_hub_app/modules/schedule/schedule_controller.dart';
import 'package:get/get.dart';
import 'package:admin_hub_app/modules/login/login_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ScheduleController>(() => ScheduleController(), fenix: true);
  }
}
