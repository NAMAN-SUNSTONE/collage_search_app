import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/content_view/lecture_meta_data_model.dart';

class AttendanceModel {
  late final int eventId;
  late final List<StudentModel> studentList;
  late final String title;
  AttendanceModel({required this.studentList, required this.title});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    eventId = json['id'];
    title = json['event_title'];
    studentList = json['student_list'] == null
        ? []
        : json['student_list']
            .map((e) => StudentModel.fromJson(e))
            .toList()
            .cast<StudentModel>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = eventId;
    data['event_title'] = title;
    data['student_list'] = studentList.map((e) => e.toJson()).toList();

    return data;
  }
}

class StudentModel {
  late final int studentId;
  late final String name;
  late final String sunstoneEmail;
  late final int timeTableId;
  late String isPresent;
  late final String date;
  String? mobile;

  StudentModel(
      {required this.studentId,
      required this.name,
      required this.sunstoneEmail,
      required this.timeTableId,
      required this.isPresent,
      required this.date,
      this.mobile});

  StudentModel.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'] ?? 0;
    name = json['name'] ?? '';
    sunstoneEmail = json['sunstone_email'] ?? '';
    timeTableId = json['time_table_id'] ?? 0;
    isPresent = json['is_present'] ?? '';
    date = json['date'] ?? '';
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['name'] = name;
    data['sunstone_email'] = sunstoneEmail;
    data['time_table_id'] = timeTableId;
    data['is_present'] = isPresent;
    data['date'] = date;
    data['mobile'] = mobile;
    return data;
  }
}

class StudentAttendanceModel {
  late final int timeTableId;
  late final String isPresent;
  late final int studentId;

  StudentAttendanceModel(
      {required this.timeTableId,
      required this.isPresent,
      required this.studentId});

  StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    timeTableId = json['time_table_id'];
    isPresent = json['is_present'];
    studentId = json['student_id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};

    json['time_table_id'] = timeTableId;
    json['is_present'] = isPresent;
    json['student_id'] = studentId;
    return json;
  }
}

class OfflineStudentAttendanceModel {

  const OfflineStudentAttendanceModel({required this.eventId, required this.isAttendanceTaken, required this.uploaded, required this.data});

  final int eventId;
  final bool isAttendanceTaken;
  final bool uploaded;
  final List<StudentAttendanceModel> data;
}
