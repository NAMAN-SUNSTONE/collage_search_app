import 'package:admin_hub_app/modules/attendance_report/repo/attendance_repo.dart';
import 'package:admin_hub_app/modules/content_view/quiz/lms_quiz_repo.dart';
import 'package:admin_hub_app/modules/login/repo/login_repo.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_repo.dart';
import 'package:admin_hub_app/modules/schedule/schedule_controller.dart';
import 'package:admin_hub_app/modules/timetable/repo/student_repo.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/event_detail/repo/event_repo.dart';
import 'package:admin_hub_app/remote_config/remote_config.dart';
import 'package:get/get.dart';
import 'package:ss_network/ss_network_client.dart';

Future setupGet() async {
  Get.create<SSNetworkClient>(() => SSNetworkClient(), permanent: false);
  // all the repos
  Get.lazyPut<LoginRepo>(() => LoginRepo(), fenix: true);
  Get.lazyPut<ScheduleRepo>(() => ScheduleRepo(), fenix: true);
  Get.lazyPut<AttendanceRepo>(() => AttendanceRepo(), fenix: true);
  Get.lazyPut<StudentRepo>(() => StudentRepo(), fenix: true);
  Get.lazyPut<EventRepo>(() => EventRepo(), fenix: true);

  Get.lazyPut<RemoteConfig>(() => RemoteConfig(), fenix: true);
  Get.lazyPut<ScheduleController>(() => ScheduleController(), fenix: true);
  Get.lazyPut<LmsQuizRepo>(() => LmsQuizRepo(), fenix: true);
}
