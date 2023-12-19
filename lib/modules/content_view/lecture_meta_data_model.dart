import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';

class LectureMetaDataModel {
  late String topic;
  late String domain;
  late List<String> attachment;
  late String description;
  late String professorName;
  late final int? courseId;
  late final int? moduleId;
  late final LectureModel? lecture;
  late final String? courseDeeplink;
  late List<LectureModel> todayLectures;
  late List<LectureModel> otherLectures;

  LectureMetaDataModel({
    required this.topic,
    required this.domain,
    required this.attachment,
    required this.description,
    required this.professorName,
    required this.courseId,
    required this.moduleId,
    required this.lecture,
    required this.courseDeeplink,
    required this.todayLectures,
    required this.otherLectures
  });
  LectureMetaDataModel.fromJson(Map<String, dynamic> json) {
    topic = json['topic'] ?? '';
    domain = json['domain'] ?? '';
    attachment = json['attachment']?.cast<String>() ?? <String>[];
    description = json['description'] ?? '';
    professorName = json['professor_name'] ?? '';
    courseId = json['course_id'];
    moduleId = json['module_id'];
    courseDeeplink = json['course_deeplink'];
    lecture = json['lecture'] != null ? LectureModel.fromJson(json['lecture']) : null;
    todayLectures = (json['current_lectures'] as List?)?.map((e) => LectureModel.fromJson(e)).toList() ?? [];
    otherLectures = (json['other_lectures'] as List?)?.map((e) => LectureModel.fromJson(e)).toList() ?? [];
  }
}
