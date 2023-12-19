part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();

  static const launchPage = Paths.splash;
}

abstract class Paths {
  static const splash = '/';
  static const beacon = '/beacon';
  static const login = '/login';
  static const schedule = '/schedule';
  static const eventDetail = '/event_detail';
  static const attendanceReport = '/attendance_report';
  static const viewImage = '/view_image';
  static const imageUploader = '/image_uploader';
  static const dashboard = '/dashboard';
  static const lms = '/lms';
  static const idRoute = '/:id';
  static const contentView = '/content_view';
  static const lectureDetailView = '/lectureDetail';
  static const lmsModule = '/lms_module';
  static const webView = '/webView';

  static String generateIdRoute(String parentRoute, id) =>
      (id is String || id is int) ? "$parentRoute/$id" : parentRoute;
}
