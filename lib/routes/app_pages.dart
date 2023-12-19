import 'package:admin_hub_app/modules/attendance_report/view/attendance_report_binding.dart';
import 'package:admin_hub_app/modules/attendance_report/view/attendance_report_controller.dart';
import 'package:admin_hub_app/modules/attendance_report/view/attendance_report_view.dart';
import 'package:admin_hub_app/modules/dashboard/dashboard_binding.dart';
import 'package:admin_hub_app/modules/dashboard/dashboard_view.dart';
import 'package:admin_hub_app/modules/image_uploader/binding.dart';
import 'package:admin_hub_app/modules/image_uploader/view.dart';
// import 'package:admin_hub_app/modules/schedule/event_detail/schedule_binding.dart';
// import 'package:admin_hub_app/modules/schedule/event_detail/schedule_view.dart';
import 'package:admin_hub_app/modules/schedule/schedule_binding.dart';
import 'package:admin_hub_app/modules/schedule/schedule_view.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/event_detail/event_detail_binding.dart';
import 'package:admin_hub_app/webview/webview_binding.dart';
import 'package:admin_hub_app/webview/webview_view.dart';
import 'package:admin_hub_app/widgets/view_image/view_image_screen.dart';
import 'package:get/get.dart';
import 'package:admin_hub_app/modules/beacon/beacon_binding.dart';
import 'package:admin_hub_app/modules/beacon/beacon_view.dart';
import 'package:admin_hub_app/modules/login/login_binding.dart';
import 'package:admin_hub_app/modules/login/login_view.dart';
import 'package:admin_hub_app/modules/splash/splash_binding.dart';
import 'package:admin_hub_app/modules/splash/splash_view.dart';

import '../modules/content_view/content_middleware.dart';
import '../modules/content_view/content_view.dart';
import '../modules/subjects/lms/lms_binding.dart';
import '../modules/subjects/lms/lms_middleware.dart';
import '../modules/subjects/lms/lms_view.dart';
import '../modules/subjects/module_view/module_binding.dart';
import '../modules/subjects/module_view/module_view.dart';
import '../modules/timetable/scheduler/event_detail/event_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.launchPage;

  static final routes = [
    GetPage(
        name: Paths.splash,
        page: () => const SplashView(),
        binding: SplashBinding()),
    GetPage(
        name: Paths.beacon,
        page: () => const BeaconView(),
        binding: BeaconBinding()),
    GetPage(
        name: Paths.login,
        page: () => const LoginView(),
        binding: LoginBinding()),
    // GetPage(
    //     name: Paths.schedule,
    //     page: () => const ScheduleView(),
    //     binding: ScheduleBinding()),
    GetPage(
        name: Paths.lectureDetailView,
        page: () => EventDetailView(),
        binding: EventDetailBinding()),
    GetPage(
        name: Paths.attendanceReport,
        page: () => const AttendanceReportView(),
        binding: AttendanceReportBinding()),
    GetPage(
      name: Paths.viewImage,
      page: () => ViewImage(),
    ),
    GetPage(
        name: Paths.imageUploader,
        page: () => ImageUploaderView(),
        binding: ImageUploaderBinding()),
    GetPage(
        name: Paths.dashboard,
        page: () => DashboardView(),
        binding: DashboardBinding()),
    GetPage(
        name: Paths.lms,
        page: () => LmsView(),
        binding: LmsBinding(),
        // middlewares: [LmsMiddleware()],
        children: [
          //page to show job detail
          GetPage(
              name: Paths.idRoute,
              page: () => ModuleView(),
              binding: ModuleViewBinding()),
        ]),
    GetPage(
        name: Paths.lmsModule,
        page: () => ModuleView(),
        binding: ModuleViewBinding()),
    GetPage(
      name: Paths.contentView,
      page: () => ContentView(),
      // middlewares: [ContentMiddleware()],
    ),
    GetPage(
      name: Paths.webView,
      page: () => WebViewView(),
      binding: WebViewBinding()
    ),
  ];
}
