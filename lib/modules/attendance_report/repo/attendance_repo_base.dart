import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';

abstract class AttendanceRepoBase {

  Future getAttendance({required String timeTableId});

  Future submitAttendance({required List<StudentAttendanceModel> attendance});

  Future editAttendance({required List<StudentAttendanceModel> attendance});

  Future resetAttendance({required String eventId});

  Future getAttendanceSubject({String? type = null, int? termNumber = null});
}
