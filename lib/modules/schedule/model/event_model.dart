class EventModel {
  int? id;
  int? lectureMapId;
  int? admissionYear;
  String? lectureDate;
  String? sectionId;
  String? campusName;
  String? section;
  String? programName;
  String? summary;
  String? lectureStartTime;
  String? lectureEndTime;
  String? classType;
  int? trimester;
  String? subjectName;
  String? roomNo;
  int? duration;
  int? studentCount;
  int? studentPresent;
  int? studentAbsent;
  late bool isToday;
  late List<String> images;
  late final bool isAttendanceTaken;
  Category? category;

  EventModel(
      {this.id,
      this.lectureMapId,
      this.admissionYear,
      this.lectureDate,
      this.sectionId,
      this.campusName,
      this.section,
      this.programName,
      this.summary,
      this.lectureStartTime,
      this.lectureEndTime,
      this.classType,
      this.trimester,
      this.subjectName,
      this.roomNo,
      this.duration,
      this.studentCount ,
      this.studentAbsent ,
      this.studentPresent,
      this.isToday = false,
      this.images=const  [],
      this.isAttendanceTaken = false,
      this.category});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lectureMapId = json['lecture_map_id'];
    admissionYear = json['admission_year'];
    lectureDate = json['lecture_date'];
    sectionId = json['section_id'];
    campusName = json['campus_name'];
    section = json['section'];
    programName = json['program_name'];
    summary = json['summary'];
    lectureStartTime = json['lecture_start_time'];
    lectureEndTime = json['lecture_end_time'];
    classType = json['class_type'];
    trimester = json['trimester'];
    subjectName = json['subject_name'];
    roomNo = json['room_no'];
    duration = json['duration'];
    studentCount = json['student_count'];
    studentAbsent = json['students_absent'];
    studentPresent = json['students_present'];
    isToday = json['is_today'] ?? false;
    images = json['attendance_image_mapping']?.cast<String>()??[];
    isAttendanceTaken = json['is_attendance_taken'] == '1';
    if (json['category'] != null)
      category = Category.fromJson(json['category']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lecture_map_id'] = lectureMapId;
    data['admission_year'] = admissionYear;
    data['lecture_date'] = lectureDate;
    data['section_id'] = sectionId;
    data['campus_name'] = campusName;
    data['section'] = section;
    data['program_name'] = programName;
    data['summary'] = summary;
    data['lecture_start_time'] = lectureStartTime;
    data['lecture_end_time'] = lectureEndTime;
    data['class_type'] = classType;
    data['trimester'] = trimester;
    data['subject_name'] = subjectName;
    data['room_no'] = roomNo;
    data['duration'] = duration;
    data['student_count'] = studentCount;
    data['students_absent'] = studentAbsent;
    data['students_present'] = studentPresent;
    data['is_today'] = isToday;
    data['attendance_image_mapping'] = images;
    data['is_attendance_taken'] = isAttendanceTaken ? '1' : '0';
    if (category != null) data['category'] = category!.toJson();
    return data;
  }
}

class Category {
  late final String identifier;
  late final String label;
  late final String bgColor;
  late final String fgColor;
  late final String cardColor;
  late final String accentColor;

  Category.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'] ?? '';
    label = json['label'] ?? '';
    bgColor = json['bg_color'] ?? '';
    fgColor = json['fg_color'] ?? '';
    cardColor = json['card_color'] ?? '';
    accentColor = json['accent_color'] ?? '';
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['identifier'] = identifier;
    json['label'] = label;
    json['bg_color'] = bgColor;
    json['fg_color'] = fgColor;
    json['card_color'] = cardColor;
    json['accent_color'] = accentColor;
    return json;
  }
}
