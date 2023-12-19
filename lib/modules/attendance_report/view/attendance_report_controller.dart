import 'package:admin_hub_app/analytics/events/screens/attendance_report.dart';
import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';
import 'package:admin_hub_app/modules/attendance_report/repo/attendance_repo.dart';
import 'package:admin_hub_app/modules/beacon/beacon_controller.dart';
import 'package:admin_hub_app/modules/calendar/ui/widgets/taught_lecture_list.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/image_uploader/controller.dart';
import 'package:admin_hub_app/modules/login/logout_sheet.dart';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/event_detail/repo/event_repo.dart';
import 'package:admin_hub_app/network/ss_alert.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:admin_hub_app/widgets/view_image/view_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceReportController extends BaseController {
  final AttendanceRepo _repo = Get.find();
  late final LectureEventListModel event;
  AttendanceModel? attendance;
  List<StudentModel> rootList = [];
  RxList<StudentModel> studentList = <StudentModel>[].obs;
  String? formattedDateTime;
  RxList<int> changes = <int>[].obs;
  RxBool isAbsentFirst = true.obs;

  RxInt presentCount = 0.obs;
  RxInt absentCount = 0.obs;
  TextEditingController textFieldController = TextEditingController();
  FocusNode focusNode = FocusNode();
  final EventRepo _eventRepo = Get.find<EventRepo>();

  String get title => attendance?.title ?? '';
  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments is! LectureEventListModel) {
      failed();
      return;
    }
    loading();
    try {
      event = Get.arguments as LectureEventListModel;
      textFieldController.addListener(onSearch);
      changes.clear();
      formattedDateTime = parseDate(event.lectureDate);
      attendance = await _repo.getAttendance(timeTableId: event.id.toString());
      await _applyOfflineData();
      await _applyOfflineImages();
      rootList = attendance?.studentList ?? [];
      _sortAndFilterList();
      computeAttendance();
      success();
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage(e.toString());
      failed();
    }
  }

  Future<void> _applyOfflineData() async {

    OfflineStudentAttendanceModel? offlineData = await DatabaseHelper.fetchStudentAttendanceListById(eventId: event.id);
    if (offlineData == null) return;
    if (await ConnectivityManager.isOnline() && offlineData.uploaded) return;

    event.isAttendanceTaken = offlineData.isAttendanceTaken || offlineData.uploaded;
    for (StudentModel student in attendance!.studentList) {
      for (StudentAttendanceModel studentAttendance in offlineData.data) {
        if (student.studentId == studentAttendance.studentId) {
          student.isPresent = studentAttendance.isPresent;
          break;
        }
      }
    }
  }

  Future<void> _applyOfflineImages() async {

    if (await ConnectivityManager.isOnline()) return;

    List<String> localImages = await DatabaseHelper.fetchAttendanceImagesByEventId(eventId: event.id);
    event.localImages = localImages;
  }

  RxBool allPresentToggle = true.obs;
  RxBool isBatchToggleActive = false.obs;

  onToggleClick(val) {
    allPresentToggle.value = val;
    batchUpdate(allPresentToggle.value);
    isBatchToggleActive.value = true;
  }

  batchUpdate(bool markAllPresent) {
    rootList.forEach((StudentModel student) {
      bool isPresent = isStudentPresent(student);

      if (markAllPresent) {
        if (!isPresent) {
          onChange(student);
        }
      } else {
        if (isPresent) {
          onChange(student);
        }
      }
    });
  }

  bool isStudentPresent(StudentModel student) {
    final bool isPresent = (student.isPresent == '1');
    return changes.contains(student.studentId) ? (!isPresent) : isPresent;
  }

  onSortButtonClick() {
    textFieldController.clear();
    focusNode.unfocus();
    isAbsentFirst.value = !isAbsentFirst.value;
    _sortAndFilterList(absentFirst: isAbsentFirst.value);
  }

  _sortAndFilterList({bool absentFirst = true}) {
    List<StudentModel> presentStudents = [];
    List<StudentModel> absentStudents = [];

    for (StudentModel student in rootList) {
      isStudentPresent(student)
          ? presentStudents.add(student)
          : absentStudents.add(student);
    }

    _sortListNameWise(absentStudents);
    _sortListNameWise(presentStudents);
    rootList.clear();

    if (absentFirst) {
      rootList.addAll(absentStudents);
      rootList.addAll(presentStudents);
    } else {
      rootList.addAll(presentStudents);
      rootList.addAll(absentStudents);
    }

    refreshCurrentList();
  }

  dispose() {
    super.dispose();
    textFieldController.dispose();
    focusNode.dispose();
  }

  refreshCurrentList() {
    studentList.value = rootList.toList();
  }

  onSearch() {
    refreshCurrentList();
    if (textFieldController.text != '')
      studentList.removeWhere((element) => !element.name
          .toLowerCase()
          .contains(textFieldController.text.toLowerCase()));
  }

  onSearchClear() {
    textFieldController.clear();
    if (focusNode.hasFocus) focusNode.unfocus();
  }

  computeAttendance() {
    if (attendance == null) return;
    presentCount.value = 0;
    absentCount.value = 0;
    for (StudentModel student in rootList) {
      isStudentPresent(student)
          ? (presentCount.value++)
          : (absentCount.value++);
    }
  }

  String parseDate(String date) {
    final DateFormat format = DateFormat("EEEE, dd MMM''yy'");
    final DateTime dateTime = DateTime.parse(date);
    return format.format(dateTime);
  }

  onImageClick(String image) {
    Get.toNamed(Paths.imageUploader, arguments: ImageUploaderArguments(event))
        ?.then((value) {
      refresh();
    });
  }

  onChange(StudentModel student) {
    isBatchToggleActive.value = false;
    final int id = student.studentId;
    if (changes.contains(id)) {
      changes.remove(id);
    } else {
      changes.add(id);
    }
    computeAttendance();
  }

  onUndoChanges() {
    changes.clear();
    computeAttendance();
  }

  _sortListNameWise(List<StudentModel> list) {
    list.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  Future _reset() async {
    loading();
    try {
      await _repo.resetAttendance(eventId: event.id.toString());
      Get.back();
      Get.toNamed(Paths.beacon,
          arguments: BeaconArguments(event: event, onRefresh: () {}));
    } catch (e) {
      showErrorMessage(e.toString());
      debugPrint(e.toString());
    }
    success();
  }

  Future<bool> onPop() async {
    if (changes.isEmpty) {
      return true;
    } else {
      showMyBottomModalSheet(
        Get.context!,
        ConfirmSheet(
            title: 'Do you want to go back without saving?',
            message: 'You will lose all the changes if you go back',
            onYes: () async {
              Get.back();
            },
            onNo: () {}),
      );
      return false;
    }
  }

  onReset() async {
    if (!(await ConnectivityManager.isOnline())) {
      showSuccessMessage("This feature is not available in offline mode");
      return;
    }
    showMyBottomModalSheet(
      Get.context!,
      ConfirmSheet(
          title: 'Are you sure you want to Reset the Attendance?',
          message:
              'If yes, attendance process will begin again, turn on bluetooth.',
          onYes: _reset,
          onNo: () {}),
    );
  }

  onRetake() async {
    if (!(await ConnectivityManager.isOnline())) {
      showSuccessMessage("This feature is not available in offline mode");
      return;
    }
    showMyBottomModalSheet(
      Get.context!,
      ConfirmSheet(
          title: 'Are you sure you want to Retake Attendance?',
          message:
              'If yes, attendance process will begin for students who were marked absent',
          onYes: () async {
            Get.back();
            Get.toNamed(Paths.beacon,
                arguments: BeaconArguments(event: event, onRefresh: () {}));
          },
          onNo: () {}),
    );
  }

  void onTapEditLecture() {
    BuildContext? context = Get.context;
    if (context == null) return;

    showMyBottomModalSheet(
        context,
        TaughtLectureList(
            event: event,
            todayLectures: event.metaData.todayLectures,
            otherLectures: event.metaData.otherLectures,
            ctaText: 'Update',
            onTapCta: (lecture) {
              Navigator.pop(context);
              markLecture(event, lecture);
            }),
        color: HubColor.white);
  }

  Future<void> markLecture(LectureEventListModel event, LectureModel lecture) async {
    loading();
    try {
      await _eventRepo.markLecture(eventId: event.id, type: event.classType, lectureId: lecture.id);
      event.metaData.todayLectures = [lecture];
      Get.offNamed(Paths.attendanceReport, arguments: event);
    } catch (e) {
      debugPrint(e.toString());
    }
    success();
  }

  onSubmit() async {
    loading();

    try {

      if ((await  ConnectivityManager.isOnline())) {
        if (event.isAttendanceTaken) {
          final List<StudentAttendanceModel> list = getAttendanceForEditing();
          if (list.isNotEmpty) {
            await _repo.editAttendance(attendance: getAttendanceForEditing());
          }
        } else {
          await _repo.submitAttendance(attendance: getAttendanceForSubmission());
        }
        AttendanceReportPageEvents().submitAttendance(event);
      } else {
        await DatabaseHelper.saveStudentAttendanceList(eventId: event.id, isAttendanceTaken: event.isAttendanceTaken, studentAttendance: getAttendanceForEditing());
      }
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage(e.toString());
    }
    success();
  }

  List<StudentAttendanceModel> getAttendanceForSubmission({bool? allPresent}) {
    List<StudentAttendanceModel> attendanceList = [];
    for (StudentModel student in rootList) {
      String isPresent;

      if (allPresent != null) {
        isPresent = allPresent ? '1' : '0';
      } else {
        isPresent = isStudentPresent(student) ? '1' : '0';
      }

      attendanceList.add(StudentAttendanceModel(
          timeTableId: student.timeTableId,
          studentId: student.studentId,
          isPresent: isPresent));
    }
    return attendanceList;
  }

  List<StudentAttendanceModel> getAttendanceForEditing() {
    List<StudentAttendanceModel> attendanceList = [];

    for (StudentModel student in rootList) {
      attendanceList.add(StudentAttendanceModel(
          timeTableId: student.timeTableId,
          studentId: student.studentId,
          isPresent: isStudentPresent(student) ? '1' : '0'));
    }

    return attendanceList;
  }
}
