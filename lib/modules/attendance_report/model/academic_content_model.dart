import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:flutter/material.dart';

import '../../../constants/enums.dart';
import '../../content_view/lecture_model.dart';
import '../../content_view/target_model.dart';
import '../../subjects/data/class_count_model.dart';
import '../../subjects/data/faculty_model.dart';
// import 'package:hub/academic_content/base/group_chat_data.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/data/student/models/class_count_model.dart';
// import 'package:hub/data/student/models/faculty_model.dart';
// import 'package:hub/data/student/models/lecture_model.dart';
// import 'package:hub/data/student/models/target_model.dart';
// import 'package:hub/utils/extensions.dart';

class AcademicContentModel {
  late final int id;
  late final String title;
  late final String description;
  late final List<Color> headerColor;
  late final List<Tags> tags;
  BannerMedia? bannerMedia;
  BannerMedia? introMedia;
  Certificates? certificates;
  late final String preRequisite;
  late final List<Module> modules;
  late final List<Content> chapters;
  late final List<Assignment> assignments;
  late final List<Content> workshopContentList;
  late final List<String> attachments;
  late final List<Speaker> speaker;
  late final bool isEnrollable;
  Progress? progress;
  String? lastEnrollmentDate;
  // GroupChatData? groupChatData;

  late final List<LectureEventListModel>? recentClasses;
  late final List<Faculty>? professors;
  late final ClassCount? attendanceCount;
  late final String? courseOverView;
  late final List<Module> assignmentAndQuizModules;
  late final int? specializationId;

  AcademicContentModel(
      {this.id = 0,
        this.title = '',
        this.description = '',
        this.headerColor = const [Color(0xffEAF2F7), Color(0xff176B9D)],
        this.tags = const [],
        this.bannerMedia,
        this.introMedia,
        this.certificates,
        this.preRequisite = '',
        this.isEnrollable = true,
        this.modules = const [],
        this.chapters = const [],
        this.assignments = const [],
        this.attachments = const [],
        this.progress,
        this.lastEnrollmentDate,
        // this.groupChatData,
        this.specializationId,
        this.assignmentAndQuizModules = const [],
        this.courseOverView,
        this.attendanceCount,
        this.professors,
        this.recentClasses,
        required this.workshopContentList});

  AcademicContentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    specializationId = json['specialization_id'];
    headerColor = json['header_color'] == null
        ? const [Color(0xffEAF2F7), Color(0xff176B9D)]
        : json['header_color']
        .cast<String>()
        .map((String e) => e.toColor2())
        .toList()
        .cast<Color>();
    json['tags'] != null
        ? tags = json['tags'].map((e) => Tags.fromJson(e)).toList().cast<Tags>()
        : tags = [];

    bannerMedia = json['banner_media'] != null
        ? new BannerMedia.fromJson(json['banner_media'])
        : null;
    introMedia = json['intro_media'] != null
        ? new BannerMedia.fromJson(json['intro_media'])
        : null;
    certificates = json['certificates'] != null
        ? new Certificates.fromJson(json['certificates'])
        : null;
    preRequisite = json['pre_requisite'] ?? '';

    modules = json['modules'] != null
        ? json['modules'].map((v) => Module.fromJson(v)).toList().cast<Module>()
        : const [];

    chapters = json['chapters'] != null
        ? json['chapters']
        .map((v) => Content.fromJson(v))
        .toList()
        .cast<Content>()
        : const [];

    assignments = json['assignments'] != null
        ? json['assignments']
        .map((v) => Assignment.fromJson(v))
        .toList()
        .cast<Assignment>()
        : const [];

    attachments = json['attachments'] != null
        ? json['attachments'].cast<String>()
        : const [];

    speaker = json['speaker'] != null
        ? json['speaker']
        .map((v) => Speaker.fromJson(v))
        .toList()
        .cast<Speaker>()
        : const [];
    if (json['progress'] != null)
      progress = Progress.fromJson(json['progress']);

    lastEnrollmentDate = json['last_enrollment_date'];
    isEnrollable = json['is_enrollable'] ?? true;
    // if (json['group_chat'] != null) {
    //   groupChatData = GroupChatData.fromJson(json['group_chat']);
    // }

    professors = (json['panel_users'] as List?)
        ?.map((professorJson) => Faculty.fromJson(professorJson))
        .toList()
        .cast<Faculty>();

    attendanceCount = (json['attendance'] != null)
        ? ClassCount.fromJson(json['attendance'])
        : null;

    recentClasses = (json['recent_classes'] as List?)
        ?.map((eventJson) => LectureEventListModel.fromJson(eventJson))
        .toList()
        .cast<LectureEventListModel>();

    courseOverView = json['course_overview'] ?? '';
    assignmentAndQuizModules = json['assignment_and_quiz_modules'] != null
        ? json['assignment_and_quiz_modules']
        .map((v) => Module.fromJson(v))
        .toList()
        .cast<Module>()
        : const [];
    workshopContentList = (json['content'] as List?)
        ?.map((contentJson) => Content.fromJson(contentJson))
        .toList()
        .cast<Content>()
        .toList() ??
        [];
  }
}

class Progress {
  late bool isStarted;
  late final int? completedPercentage;

  Progress({this.isStarted = false, this.completedPercentage});

  Progress.fromJson(Map<String, dynamic> json) {
    isStarted = json['is_started'] ?? '';
    completedPercentage = json['completed_percentage'];
  }
}

class Speaker {
  late final String name;
  late final String description;
  late final String image;
  Speaker({this.name = '', this.description = '', this.image = ''});

  Speaker.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    image = json['image'] ?? '';
  }
}

class Tags {
  late final String name;

  Tags({this.name = ''});

  Tags.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class BannerMedia {
  String? type;
  String? url;
  String? thumbnail;
  String? title;
  String? description;
  int? duration;

  BannerMedia(
      {this.type,
        this.url,
        this.thumbnail,
        this.title = '',
        this.description = '',
        this.duration});

  BannerMedia.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    data['title'] = this.title;
    data['description'] = this.description;
    data['duration'] = this.duration;
    return data;
  }
}

class Certificates {
  List<CertificatesAchieved>? certificatesAchieved;
  List<CertificatesAchieved>? sampleCertificates;

  Certificates({this.certificatesAchieved, this.sampleCertificates});

  Certificates.fromJson(Map<String, dynamic> json) {
    if (json['certificates_achieved'] != null) {
      certificatesAchieved = <CertificatesAchieved>[];
      json['certificates_achieved'].forEach((v) {
        certificatesAchieved!.add(new CertificatesAchieved.fromJson(v));
      });
    }
    if (json['sample_certificates'] != null) {
      sampleCertificates = <CertificatesAchieved>[];
      json['sample_certificates'].forEach((v) {
        sampleCertificates!.add(new CertificatesAchieved.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.certificatesAchieved != null) {
      data['certificates_achieved'] =
          this.certificatesAchieved!.map((v) => v.toJson()).toList();
    }
    if (this.sampleCertificates != null) {
      data['sample_certificates'] =
          this.sampleCertificates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CertificatesAchieved {
  String? title;
  String? certificateImage;

  CertificatesAchieved({this.title, this.certificateImage});

  CertificatesAchieved.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    certificateImage = json['certificate_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['certificate_image'] = this.certificateImage;
    return data;
  }
}

enum ContentType {
  content,
  time_table,
  assignment,
  quiz,
  web_view,
  youtube_url,
  document
}

class Content {
  late final int id;
  late final String title;
  late final ContentType type;
  late final ContentType academicType;
  late final bool seen;
  late final bool isAvailable;
  DateTime? startTime;
  DateTime? endTime;
  BannerMedia? media;
  Target? target;
  LmsAssessmentModel? assignment;
  LmsAssessmentModel? quiz;
  List<ClassRecordingModel>? recordings;

  Content(
      {this.id = -1,
        this.title = '',
        this.isAvailable = false,
        this.startTime,
        this.endTime,
        this.seen = false,
        this.type = ContentType.time_table,
        this.media,
        this.academicType = ContentType.content,
        this.target,
        this.recordings,
        this.assignment,
        this.quiz});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    title = json['title'] ?? '';
    isAvailable = json['is_available'] ?? false;
    if (json['start_time'] != null)
      startTime = (json['start_time'] as String).toDateTimeObject();
    if (json['end_time'] != null)
      endTime = (json['end_time'] as String).toDateTimeObject();
    seen = json['seen'] ?? false;
    type = enumFromString(ContentType.values, json['type']) ??
        ContentType.time_table;
    academicType = enumFromString(ContentType.values, json['academic_type']) ??
        ContentType.content;
    media =
    json['media'] != null ? new BannerMedia.fromJson(json['media']) : null;
    target =
    json['target'] != null ? new Target.fromJson(json['target']) : null;

    assignment = json['assignment'] != null
        ? new LmsAssessmentModel.fromJson(json['assignment'])
        : null;

    quiz = json['quiz'] != null
        ? new LmsAssessmentModel.fromJson(json['quiz'])
        : null;
    recordings = json['class_recordings']?.map<ClassRecordingModel>((json) {
      return ClassRecordingModel.fromJson(json);
    }).toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['academic_type'] = this.academicType.toShortString();
    data['id'] = this.id;
    data['title'] = this.title;
    data['is_available'] = this.isAvailable;
    data['start_time'] = this.startTime.toString();
    data['end_time'] = this.endTime.toString();
    data['seen'] = this.seen;

    data['type'] = this.type.toShortString();
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    if (this.target != null) {
      data['target'] = this.target!.toJson();
    }
    return data;
  }
}

class Assignment {
  late final String title;
  DateTime? uploadTime;
  DateTime? deadline;
  Target? target;

  Assignment(
      {this.title = '', this.uploadTime, this.deadline, required this.target});

  Assignment.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    uploadTime = (json['upload_time'] as String?)?.toDateTimeObject();
    deadline = (json['deadline'] as String?)?.toDateTimeObject();
    if (json['target'] != null) target = Target.fromJson(json['target']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['upload_time'] = uploadTime;
    data['deadline'] = deadline;

    return data;
  }
}

class Attachment {
  String? thumbnail;
  String? url;

  Attachment({this.thumbnail, this.url});

  Attachment.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumbnail'] = this.thumbnail;
    data['url'] = this.url;
    return data;
  }
}

class LmsAssessmentModel {
  final String id;
  final AssignmentStatus? status;
  final List<String>? attachments;
  final DateTime? deadlineDate;
  final DateTime? submittedDate;
  final DateTime? gradedDate;
  final int? obtainedGrade;
  final int? maxGrade;
  final String? remarks;

  LmsAssessmentModel({
    required this.id,
    this.status,
    this.deadlineDate,
    this.attachments,
    this.submittedDate,
    this.gradedDate,
    this.obtainedGrade,
    this.maxGrade,
    this.remarks,
  });

  factory LmsAssessmentModel.fromJson(Map json) {
    return LmsAssessmentModel(
      //for assignment it is int and for quiz its int
        id: json['id'].toString(),
        status: enumFromString(AssignmentStatus.values, json['status']),
        deadlineDate: (json['deadline_date'] as String?)?.toDateTimeObject(),
        submittedDate: (json['submitted_date'] as String?)?.toDateTimeObject(),
        gradedDate: (json['graded_date'] as String?)?.toDateTimeObject(),
        attachments: json['attachments']?.cast<String>(),
        obtainedGrade: json['obtained_grades'],
        maxGrade: json['max_grades'],
        remarks: json['remarks']);
  }
}

enum AssignmentStatus { Pending, Graded, Submitted, Overdue }

class Module {
  final int id;
  final String? title;
  final List<Content> contents;
  final List<LectureModel>? lectures;
  final String? subjectName;

  Module(
      {required this.id, this.title, this.contents = const [], this.lectures, this.subjectName});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
        id: json['id'],
        title: json['name'],
        contents: (json['content'] as List?)
            ?.map((contentJson) => Content.fromJson(contentJson))
            .toList()
            .cast<Content>() ??
            [],
        lectures: (json['lectures'] as List?)
            ?.map((contentJson) => LectureModel.fromJson(contentJson))
            .toList()
            .cast<LectureModel>(),
        subjectName: json['subject_name']
    );
  }
}


class LectureModel {
  final int id;
  final String title;
  final String? handbookUrl;
  final List<Content> content;

  const LectureModel({required this.id, required this.title, this.handbookUrl, required this.content});

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['id'],
      title: json['title'],
      handbookUrl: json['handbook_url'],
      content: (json['content'] as List?)
          ?.map((contentJson) => Content.fromJson(contentJson))
          .toList()
          .cast<Content>() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    if (handbookUrl != null) 'handbook_url': handbookUrl,
    'contents': content.map((e) => e.toJson()).toList()
  };
}

