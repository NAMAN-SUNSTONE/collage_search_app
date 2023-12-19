import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';
import 'package:admin_hub_app/modules/attendance_report/repo/attendance_repo_base.dart';

class AttendanceRepoMock implements AttendanceRepoBase {
  @override
  Future getAttendance({required String timeTableId}) {
    throw UnimplementedError();
  }

  @override
  Future submitAttendance({required List<StudentAttendanceModel> attendance}) {
    throw UnimplementedError();
  }

  @override
  Future editAttendance({required List<StudentAttendanceModel> attendance}) {
    throw UnimplementedError();
  }

  @override
  Future resetAttendance({required String eventId}) {
    throw UnimplementedError();
  }

  @override
  Future getAttendanceSubject({String? type = null, int? termNumber = null}){
    // TODO: implement getAttendanceSubject
    throw UnimplementedError();
  }
}
