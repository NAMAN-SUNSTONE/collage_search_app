import 'package:admin_hub_app/modules/attendance_report/view/attendance_report_controller.dart';
import 'package:get/get.dart';

class AttendanceReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceReportController>(() => AttendanceReportController(),fenix: true);
  }
}
