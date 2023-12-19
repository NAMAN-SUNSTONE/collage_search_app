import 'package:get/get.dart';
import 'package:hub/ui/home/home_controller.dart';
import 'package:hub/ui/timetable/timetable_controller.dart';

class TimetableBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TimetableController>(() => TimetableController(), fenix: true);
  }
}