import 'package:admin_hub_app/constants/error.dart';
import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';
import 'package:admin_hub_app/modules/attendance_report/repo/attendance_repo_base.dart';
import 'package:admin_hub_app/modules/attendance_report/repo/attendance_service.dart';
import 'package:admin_hub_app/modules/subjects/data/attendance_subject_model.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:get/get.dart';

class AttendanceRepo implements AttendanceRepoBase {
  @override
  Future<AttendanceModel> getAttendance({required String timeTableId}) async {

    bool isConnected = await ConnectivityManager.isOnline();
    if (!isConnected) {
      AttendanceModel? attendance =
          await DatabaseHelper.fetchAttendanceById(int.parse(timeTableId));
      if (attendance != null) {
        return attendance;
      } else {
        throw SSActionException(
            ErrorMessages.unknown, ErrorMessages.generic, 0);
      }
    }

    final response = await AttendanceService.getAttendance(timeTableId);

    return AttendanceModel.fromJson(response);
  }

  @override
  Future submitAttendance(
      {required List<StudentAttendanceModel> attendance, bool isOffline = false}) async {
    final List<Map<String, dynamic>> attendanceList =
        attendance.map((e) => e.toJson()).toList();

    await AttendanceService.submitAttendance(attendanceList, isOffline: isOffline);
  }

  @override
  Future editAttendance(
      {required List<StudentAttendanceModel> attendance, bool isOffline = false}) async {
    final List<Map<String, dynamic>> attendanceList =
        attendance.map((e) => e.toJson()).toList();

    await AttendanceService.editAttendance(attendanceList, isOffline: isOffline);
  }

  @override
  Future resetAttendance({required String eventId}) async {
    await AttendanceService.resetAttendance(eventId);
  }

  @override
  Future getAttendanceSubject({String? type, int? termNumber}) async {
    final response = await AttendanceService.getAttendanceSubject(type, termNumber);
    return AttendanceSubject.fromJson(response);
  }
}
