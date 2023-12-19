import 'package:admin_hub_app/modules/subjects/ui/widgets/term_filter.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/utils/hub_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../utils/utils.dart';
import '../../../widgets/reusables.dart';
import '../../attendance_report/repo/attendance_repo.dart';
import '../data/attendance_subject_model.dart';
import '../data/subjects_model.dart';
import '../data/terms_model.dart';
import '../lms/lms_controller.dart';
// import 'package:hub/academic_content/lms/lms_controller.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/constants/screen_names.dart';
// import 'package:hub/data/outcome.dart';
// import 'package:hub/data/student/models/attendance_subject_model.dart';
// import 'package:hub/data/student/models/subjects_model.dart';
// import 'package:hub/data/student/models/terms_model.dart';
// import 'package:hub/data/student/repos/attendance_repo.dart';
// import 'package:hub/data/user/user.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/routes/page_navigator.dart';
// import 'package:hub/sunstone_base/nudge/user_manager.dart';
// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/ui/home/home_controller.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/course_detail/subject_detail_controller.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/widgets/term_filter.dart';
// import 'package:hub/widgets/reusables.dart';

class SubjectsController extends BaseController {
  Rx<AttendanceSubject?> attendanceSubject = Rx<AttendanceSubject?>(null);
  RxList<Subjects> subjectList = <Subjects>[].obs;
  RxList<Terms> termsList = <Terms>[].obs;
  int currentTerm = 1;
  // User? currentUser = HubStorage.getInstance();
  late final AttendanceRepo _attendanceRepo = Get.find();

  @override
  Future<void> onInit() async {
    // AnalyticEvents.screenLoad(screenName: ScreenName.mySubjects);
    await _getAttendanceSubjects();
    super.onInit();
  }

  @override
  void onClose() {
    // AnalyticEvents.screenUnLoad(screenName: ScreenName.mySubjects);
    super.onClose();
  }

  Future<void> _getAttendanceSubjects() async {
    loading();
    try {
      attendanceSubject.value = await _attendanceRepo.getAttendanceSubject();
      if (attendanceSubject.value != null) {
        subjectList.value = attendanceSubject.value!.subjects;
        termsList.value = attendanceSubject.value!.termsList;
        currentTerm = attendanceSubject.value!.currentTerm.termNo;
      }
      success();
    } catch (e) {
      failed();
    }
  }

  Future<void> _getAttendanceSubjectsFilter(
      String? type, int? termNumber) async {
    loading();
    final result = await _attendanceRepo.getAttendanceSubject(
        type: type, termNumber: termNumber);

    try {
      attendanceSubject.value = result.data;
      if (attendanceSubject.value != null) {
        subjectList.value = attendanceSubject.value!.subjects;
        termsList.value = attendanceSubject.value!.termsList;
      }
      success();
    } catch (e) {
      failed();
    }
  }

  void onSemesterTap(context) {
    showMyBottomModalSheet(
      context,
      TermFilterSheet(
        terms: termsList,
        currentTerm: currentTerm,
        fetchedTerm: attendanceSubject.value!.currentTerm,
        onFilterSelected: onSemesterChange,
      ),
    );
  }

  Future<void> onSemesterChange(Terms term) async {
    String? type = term.type;
    int? termNumber = term.termNo;
    await _getAttendanceSubjectsFilter(type, termNumber);
    // AnalyticEvents.semesterView(termNumber ?? 0);
  }


  String? get selectedTerm => attendanceSubject.value?.currentTerm.label;

  String get courseDetailString {

    return "Mock value";

    // String? campusShortName = currentUser?.campusData.campusName;
    // String? programShortName = currentUser?.programData.name;
    // String? currentYear = currentUser?.sessionDuration;
    //
    // final formattedString = "$campusShortName ${programShortName != null ? "|"
    //     " $programShortName" : ""} | $currentYear";
    //
    // return formattedString;
  }

  void goToDetailPage(Subjects subject) {
    
    // Get.toNamed(Paths)
    
    // AnalyticEvents.subjectDetail(
    //     subjectName: subject.courseName, term: currentTerm.toString());

    // final userNudgeData = UserManager.nudge.value;
    //
    // if (userNudgeData.isLmsEnabled) {
      Get.toNamed(
          Paths.lms,
          parameters: stringifyMap(LmsParameters(
            subjectId: subject.id,
            tabIdentifier: LmsTabIdentifiers.info,
          ).toJson()));
    // } else {
    //   Get.toNamed(Paths.subjectDetailView,
    //       arguments: SubjectDetailsArgument(
    //           subject: subject, term: currentTerm.toString()));
    // }
  }
}
