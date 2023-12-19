// import 'package:hub/data/student/models/class_count_model.dart';
// import 'package:hub/data/student/models/timetable_model.dart';

import 'package:admin_hub_app/modules/subjects/data/timetable_model.dart';

import 'class_count_model.dart';

class Subjects {
  int id;
  String courseName;
  int specializationId;
  String url;
  TimetableData? timetableData;
  ClassCount classCount;

  Subjects({
    required this.id,
    required this.courseName,
    required this.specializationId,
    required this.url,
    required this.timetableData,
    required this.classCount,
  });

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(id: json['id'] ?? 0,
        courseName: json['course_name'] ?? '',
        specializationId: json['specialization_id'] ?? -1,
        url: json['canvas_subject_url'] ?? '',
        timetableData: json['time_table_data'] == null ? null : TimetableData.fromJson(json['time_table_data']),
        classCount: ClassCount.fromJson(json['class_count']));
  }

}