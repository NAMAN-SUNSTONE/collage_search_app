// import 'package:hub/data/student/models/faculty_model.dart';
// import 'package:hub/data/student/models/subject_data_model.dart';

import 'package:admin_hub_app/modules/subjects/data/subject_data_model.dart';

import 'faculty_model.dart';

class TimetableData {
  int id;
  String lectureDate;
  String lectureStartTime;
  String lectureEndTime;
  Faculty professor;
  String classType;
  String eventType;
  SubjectData courseData;
  int startDatetime;
  int endDatetime;

  TimetableData({
    required this.id,
    required this.lectureDate,
    required this.lectureStartTime,
    required this.lectureEndTime,
    required this.professor,
    required this.classType,
    required this.eventType,
    required this.courseData,
    required this.startDatetime,
    required this.endDatetime,
  });

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
        id: json['id'],
        lectureDate: json['lecture_date'],
        lectureStartTime: json['lecture_start_time'],
        lectureEndTime: json['lecture_end_time'],
        professor: Faculty.fromJson(json['professor_data']),
        classType: json['class_type'],
        eventType: json['event_type'],
        courseData: SubjectData.fromJson(json['subject_data']),
        startDatetime: json['start_datetime'],
        endDatetime: json['end_datetime']);
  }
}
