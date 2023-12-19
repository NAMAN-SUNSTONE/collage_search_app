import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/utils/getx_extension.dart';
import 'package:get/get.dart';

mixin AnalyticsScreenMapper {
  ///mapping of routes and screen names
  static const _screenMapper = {
    Paths.schedule: ScreenName.schedule,
    Paths.attendanceReport: ScreenName.attendanceReport,
    Paths.lectureDetailView: ScreenName.lectureDetail
  };

  String getCurrentScreenName() {
    final String _route = Get.currentRouteWithoutParams;
    return getScreenName(_route);
  }

  String getScreenName(String _route) {
    return _screenMapper[_route] ?? _route;
  }
}

///screens names for analytics purposes
class ScreenName {
  static const schedule = 'schedule';
  static const attendanceReport = 'attendance_report';
  static const lectureDetail = 'lecture_detail';
}
