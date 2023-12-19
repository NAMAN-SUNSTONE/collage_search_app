import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hub/ui/timetable/timetable_controller.dart';

class TimetableMiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {

    if (kIsWeb) {
      if (Get.isRegistered<TimetableController>()) {
        Get.delete<TimetableController>();
      }
    }

    return super.redirect(route);
  }
}