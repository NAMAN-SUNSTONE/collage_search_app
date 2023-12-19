// import 'package:hub/sunstone_base/data/ss_navigation.dart';
// import 'package:hub/utils/extensions.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/content_view/professor_data_model.dart';
import 'package:admin_hub_app/modules/content_view/ss_navigation.dart';
import 'package:admin_hub_app/utils/ss_file.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:intl/intl.dart';

import '../subjects/data/subject_data_model.dart';
import 'campus_room_data_model.dart';
import 'lecture_category_model.dart';
import 'lecture_meta_data_model.dart';

// import './campus_room_data_model.dart';
// import './lecture_category_model.dart';
// import './lecture_meta_data_model.dart';
// import './professor_data_model.dart';
// import './subject_data_model.dart';

class LectureEventModel {
  late String datetime;
  late List<LectureEventListModel> list;

  LectureEventModel({
    required this.datetime,
    required this.list,
  });

  LectureEventModel.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'] ?? "";

    if (json['list'] != null) {
      list = json['list']
          .map((e) => LectureEventListModel.fromJson(e))
          .toList()
          .cast<LectureEventListModel>();
    } else {
      list = [];
    }
  }
}

class LectureEventListModel {
  late int id;
  late String lectureDate;
  late String? lectureStartTime;
  late String? lectureEndTime;
  late String? type;
  late String eventType;
  late String classType;
  late String joinUrl;
  late LectureMetaDataModel metaData;
  late String summary;
  late ProfessorDataModel professorData;
  late CampusRoomDataModel campusRoomData;
  late SubjectData subjectData;
  late LectureCategoryModel category;
  String? label;
  late List<ClassRecordingModel> classRecordings;
  late List<ProfessorModel> professors;
  late List<RoomModel> rooms;
  late int? studentCount;
  late String? recurringDays;
  late bool? isStudentPresent;
  List<NotesModel>? notes;
  late List<AttachmentModel> attachments;
  late String? bannerURL;
  late bool isToShowAddNotes;
  int? lectureMapId;
  EventSubscription? subscription;
  List<SSNavigation>? actions;
  late List<String> classPictures;
  late bool isAttendanceTaken;
  String? zoomUrl;
  List<String> localImages = [];

  final DateFormat _dayFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');

  LectureEventListModel({required this.id,
    required this.lectureDate,
    required this.lectureStartTime,
    required this.lectureEndTime,
    required this.eventType,
    required this.classType,
    this.type,
    required this.joinUrl,
    required this.metaData,
    required this.summary,
    required this.professorData,
    required this.campusRoomData,
    required this.subjectData,
    required this.category,
    this.label,
    required this.rooms,
    required this.professors,
    required this.classRecordings,
    required this.studentCount,
    required this.recurringDays,
    required this.notes,
    this.isStudentPresent,
    required this.attachments,
    required this.isToShowAddNotes,
    this.bannerURL,
    this.subscription,
    required this.lectureMapId,
    this.actions,
    this.classPictures = const [],
    this.isAttendanceTaken = false,
    this.zoomUrl});

  static const String online = 'online';
  static const String room = 'room';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String deeplinkDateFormat = 'dd-MM-yyyy';

  String get displayTitle {
    return metaData.topic.isNotEmpty ? metaData.topic : subjectData.courseName;
  }

  String get lectureDateForDeepLink {
    return DateFormat(deeplinkDateFormat)
        .format(DateFormat(apiDateFormat).parse(lectureDate));
  }

  bool shouldShowRegisterButton({required String? currentServerDateTime}) {
    if (lectureStartTime != null && subscription != null) {
      DateTime _lectureDate = _dayFormat.parse(lectureDate); // only date
      DateTime _lectureEndTime = _timeFormat.parse(
          lectureEndTime!); // only time
      DateTime registrationEndTime = DateTime(
          _lectureDate.year,
          _lectureDate.month,
          _lectureDate.day,
          _lectureEndTime.hour,
          _lectureEndTime.minute,
          _lectureEndTime.second,
          _lectureEndTime.millisecond,
          _lectureEndTime.microsecond);
      DateTime currentTime = currentServerDateTime?.toDateTime() ??
          DateTime.now();

      return currentTime.isBefore(registrationEndTime);
    }

    return false;
  }

  RoomModel? get onlineRoom {
    for (RoomModel room in rooms) {
      if (room.type?.toLowerCase() == online) {
        return room;
      }
    }

    return null;
  }

  bool get hasLecture {
    return metaData.moduleId != null &&
        metaData.courseId != null &&
        metaData.lecture != null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id ?? 0;
    data['lecture_date'] = this.lectureDate ?? '';
    data['lecture_start_time'] = this.lectureStartTime;
    data['lecture_end_time'] = this.lectureEndTime;
    data['type'] = this.type;
    data['event_type'] = this.eventType ?? '';
    data['class_type'] = this.classType ?? '';
    data['join_url'] = this.joinUrl ?? '';
    data['summary'] = this.summary ?? '';
    data['lecture_map_id'] = this.lectureMapId;
    data['recurring_string'] = this.recurringDays;
    data['student_attendance_taken'] = this.isStudentPresent;
    data['student_count'] = this.studentCount ?? 0;
    data['banner_url'] = this.bannerURL ?? '';
    data['is_to_show_add_notes'] = this.isToShowAddNotes ?? true;
    data['is_attendance_taken'] = this.isAttendanceTaken ?? false;
    data['zoom_url'] = this.zoomUrl;

    // Flatten LectureMetaDataModel
    if (this.metaData != null) {
      data['meta_data'] = {
        'topic': this.metaData.topic ?? '',
        'domain': this.metaData.domain ?? '',
        'description': this.metaData.description ?? '',
        'professor_name': this.metaData.professorName ?? '',
        'course_id': this.metaData.courseId ?? 0,
        'module_id': this.metaData.moduleId ?? 0,
        'course_deeplink': this.metaData.courseDeeplink ?? '',
        'lecture': this.metaData.lecture?.toJson() ?? null
      };
    } else {
      data['meta_data'] = {};
    }

    // if (this.campusRoomData != null) {
    //   data['campus_room_map_data'] = {
    //     'room_no': this.campusRoomData.roomNo ?? '',
    //   };
    // } else {
    //   data['campus_room_map_data'] = {};
    // }

    // Flatten ProfessorDataModel
    if (this.professorData != null) {
      data['professor_data'] = {
        'name': this.professorData.name ?? '',
      };
    } else {
      data['professor_data'] = {};
    }

    // Flatten SubjectData
    if (this.subjectData != null) {
      data['subject_data'] = {
        'course_name': this.subjectData.courseName ?? '',
        'specialization_id': this.subjectData.specializationId ?? 0,
      };
    } else {
      data['subject_data'] = {};
    }

    // Flatten LectureCategoryModel (if available in the model)
    if (this.category != null) {
      data['category'] = {
        'identifier': this.category.identifier ?? '',
        'label': this.category.label ?? '',
        'bg_color': this.category.bgColor ?? '',
        'fg_color': this.category.fgColor ?? '',
        'card_color': this.category.cardColor ?? '',
        'accent_color': this.category.accentColor ?? '',
      };
    } else {
      data['category'] = {};
    }

    // Flatten ClassRecordingModel (if available in the model)
    // if (this.classRecordings != null && this.classRecordings.isNotEmpty) {
    //   data['class_recordings'] = this.classRecordings.map((recording) {
    //     return {
    //       'url': recording?.url ?? '',
    //       'thumbnail': recording?.thumbnail ?? '',
    //     };
    //   }).toList();
    // } else {
    //   data['class_recordings'] = [];
    // }

    // Flatten ProfessorModel (if available in the model)
    if (this.professors != null && this.professors.isNotEmpty) {
      data['professors'] = this.professors.map((professor) {
        return {
          'id': professor?.id ?? 0,
          'name': professor?.name ?? '',
        };
      }).toList();
    } else {
      data['professors'] = [];
    }

    // Flatten RoomModel (if available in the model)
    if (this.rooms != null && this.rooms.isNotEmpty) {
      data['rooms'] = this.rooms.map((room) {
        return {
          'type': room?.type ?? '',
          'room_number': room?.roomNumber ?? '',
          'join_url': room?.joinURL ?? '',
          'meeting_id': room?.meetingID ?? '',
          'passcode': room?.passcode ?? '',
        };
      }).toList();
    } else {
      data['rooms'] = [];
    }

    // Flatten AttachmentModel (if available in the model)
    // if (this.attachments != null && this.attachments.isNotEmpty) {
    //   data['attachments'] = this.attachments.map((attachment) {
    //     return {
    //       'title': attachment?.title ?? '',
    //       'type': attachment?.type ?? '',
    //       'url': attachment?.url ?? '',
    //     };
    //   }).toList();
    // } else {
    //   data['attachments'] = [];
    // }

    // Flatten NotesModel (if available in the model)
    // if (this.notes != null && this.notes!.isNotEmpty) {
    //   data['notes'] = this.notes?.map((note) {
    //     return {
    //       'id': note?.id ?? 0,
    //       'title': note?.title ?? '',
    //       'description': note?.description ?? '',
    //       'user_id': note?.userId ?? 0,
    //       'time_table_id': note?.timeTableId ?? 0,
    //       'status': note?.status ?? '',
    //       'created': note?.created ?? '',
    //       'modified': note?.modified ?? '',
    //     };
    //   }).toList();
    // } else {
    //   data['notes'] = [];
    // }

    // Flatten EventSubscription (if available in the model)
    // if (this.subscription != null) {
    //   data['event_subscription'] = {
    //     'is_subscribed': this.subscription!.isSubscribed ?? false,
    //     'display_label': this.subscription!.displayLabel ?? '',
    //     'actions': this.subscription!.actions?.map((action) {
    //       return {
    //         'type': action.type ?? '',
    //         'title': action.title ?? '',
    //         'icon_identifier': action.iconIdentifier ?? '',
    //         'deeplink': action.deeplink ?? '',
    //         'data_type': action.dataType?.toString() ?? '',
    //         'data': action.data ?? '',
    //       };
    //     }).toList() ?? [],
    //   };
    // } else {
    //   data['event_subscription'] = {};
    // }

    // Flatten class_pictures
    data['class_pictures'] = this.classPictures ?? [];

    return data;
  }

  LectureEventListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    lectureDate = json['lecture_date'] ?? '';
    lectureStartTime = json['lecture_start_time'];
    lectureEndTime = json['lecture_end_time'];
    type = json['type'];
    eventType = json['event_type'] ?? '';
    classType = json['class_type'] ?? '';
    joinUrl = json['join_url'] ?? '';
    metaData = LectureMetaDataModel.fromJson(json['meta_data'] ?? {});
    summary = json['summary'] ?? '';
    lectureMapId = json['lecture_map_id'];
    campusRoomData =
        CampusRoomDataModel.fromJson(json['campus_room_map_data'] ?? {});
    professorData = ProfessorDataModel.fromJson(json['professor_data'] ?? {});
    subjectData = SubjectData.fromJson(json['subject_data'] ?? {});
    category = LectureCategoryModel.fromJson(json['category'] ?? {});
    label = json['label'];
    zoomUrl = json['zoom_url'];
    recurringDays = json["recurring_string"];
    classRecordings = json['class_recordings']
        ?.map((e) => ClassRecordingModel.fromJson(e))
        ?.toList()
        .cast<ClassRecordingModel>() ??
        [];
    professors = json['professor']
        ?.map((e) => ProfessorModel.fromJson(e))
        ?.toList()
        .cast<ProfessorModel>() ??
        [];
    rooms = json['room_data']
        ?.map((e) => RoomModel.fromJson(e))
        ?.toList()
        .cast<RoomModel>() ??
        [];
    isStudentPresent = json['student_attendance_taken'];
    studentCount = json['student_count'];

    attachments = json['attachments']
        ?.map((e) => AttachmentModel.fromJson(e))
        ?.toList()
        .cast<AttachmentModel>() ??
        [];
    bannerURL = json['banner_url'];
    isToShowAddNotes = json['is_to_show_add_notes'] ?? true;
    notes = (json['notes'] as List?)
        ?.map((json) => NotesModel.fromJson(json))
        .toList()
        .cast<NotesModel>();
    if (json['event_subscription'] != null) {
      subscription = EventSubscription.fromJson(json['event_subscription']);
    }
    actions = (json['actions'] as List?)
        ?.map((e) => SSNavigation.fromJson(e))
        .toList() ??
        [];
    classPictures = json['class_pictures']?.cast<String>() ?? [];
    isAttendanceTaken = json['is_attendance_taken'] ?? false;
  }
}

class EventSubscription {
  static const String _isSubscribedKey = 'is_subscribed';
  static const String _displayLabelKey = 'display_label';
  static const String _actionsKey = 'actions';

  const EventSubscription({required this.isSubscribed,
    required this.displayLabel,
    required this.actions});

  final bool isSubscribed;
  final String displayLabel;
  final List<SSNavigation> actions;

  factory EventSubscription.fromJson(Map<String, dynamic> json) {
    bool isSubscribed = json[_isSubscribedKey];
    String displayLabel = json[_displayLabelKey];
    List<SSNavigation> actions = (json[_actionsKey] as List?)
        ?.map((e) => SSNavigation.fromJson(e))
        .toList() ??
        [];

    return EventSubscription(
        isSubscribed: isSubscribed,
        displayLabel: displayLabel,
        actions: actions);
  }
}

class NotesModel {
  late int id;
  late String title;
  late String description;
  late int userId;
  late int timeTableId;
  late String status;
  late String created;
  late String modified;
  late List<NotesAttachmentModel> attachments;

  NotesModel({required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.timeTableId,
    required this.status,
    required this.created,
    required this.modified,
    required this.attachments});

  NotesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    userId = json['user_id'] ?? 0;
    timeTableId = json['time_table_id'] ?? 0;
    status = json['status'] ?? '';
    created = json['created'] ?? '';
    modified = json['modified'] ?? '';
    attachments = (json['attachments'] != null)
        ? (json['attachments']
        .map((e) => NotesAttachmentModel.fromJson(e))
        .toList()
        .cast<NotesAttachmentModel>())
        : [];
  }
}

class NotesAttachmentModel {
  late int id;
  late String url;
  late String name;

  NotesAttachmentModel(
      {required this.id, required this.url, required this.name});

  NotesAttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    url = json['url'] ?? '';
    name = json['name'] ?? '';
  }
}

class ClassRecordingModel {
  final String? url;
  final String? thumbnail;
  final String? title;

  ClassRecordingModel({
    required this.url,
    this.thumbnail,
    this.title,
  });

  factory ClassRecordingModel.fromJson(Map<String, dynamic> json) {
    return ClassRecordingModel(url: json['url'], thumbnail: json['thumbnail']);
  }

  ClassRecordingModel copyWith({String? title}) {
    return ClassRecordingModel(
        url: url, thumbnail: thumbnail, title: title ?? this.title);
  }
}

class ProfessorModel {
  final int id;
  final String name;

  ProfessorModel({required this.id, this.name = ""});

  factory ProfessorModel.fromJson(Map<String, dynamic> json) {
    return ProfessorModel(id: json["id"], name: json['name']);
  }
}

class RoomModel {
  final String? type;
  final String? roomNumber;
  final String? joinURL;
  final String? meetingID;
  final String? passcode;

  RoomModel({required this.type,
    this.roomNumber,
    this.joinURL,
    this.meetingID,
    this.passcode});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
        type: json['type'],
        roomNumber: json['data']?['campus_room_map_data']?['room_no'],
        joinURL: json['data']?['join_url'],
        meetingID: json['data']?['meeting_id'],
        passcode: json['data']?['passcode']);
  }
}

class AttachmentModel {
  final String? title;
  final String? type;
  final String? url;

  AttachmentModel({this.title, this.type, this.url});

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
        title: json['title'], type: json['type'], url: json['url']);
  }
}
