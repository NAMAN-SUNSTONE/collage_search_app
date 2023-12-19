import 'dart:async';
import 'dart:io';

import 'package:admin_hub_app/constants/constants.dart';
import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';
import 'package:admin_hub_app/modules/attendance_report/repo/attendance_repo.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/content_view/ss_navigation.dart';
import 'package:admin_hub_app/modules/offline/attendance_image.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_repo.dart';
import 'package:admin_hub_app/modules/timetable/repo/student_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OfflineUtils {

  static final StreamController<bool> syncingStreamController = StreamController<bool>.broadcast();

  static final DateFormat _dateFormatLectureDate = DateFormat('yyyy-MM-d');
  static final DateFormat _dateFormatLectureTime = DateFormat('HH:mm:ss');

  static final StudentRepo _studentRepo = Get.find<StudentRepo>();
  static final AttendanceRepo _attendanceRepo = Get.find<AttendanceRepo>();
  static final ScheduleRepo _scheduleRepo = Get.find<ScheduleRepo>();

  static bool _isSyncing = false;

  static Future<void> sync() async {

    if (_isSyncing) return;

    _isSyncing = true;

    try {
      syncingStreamController.add(true);
      await _uploadClassImages();
      await _uploadTakenAttendance();
      await _fetchTimetable();
      await _fetchAttendance();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isSyncing = false;
      syncingStreamController.add(false);
    }
  }

  static Future<void> _fetchTimetable() async {
    DateTime offset = DateTime.now().subtract(Duration(days: 15));
    int limit = 30;
    await _studentRepo.fetchCalendarEvents(offset: offset, limit: limit);
  }

  static Future<void> _fetchAttendance() async {
    List<int> eventIds = await DatabaseHelper.fetchAttendanceMissingEvents();
    eventIds.forEach((id) async {
      AttendanceModel attendance = await _attendanceRepo.getAttendance(timeTableId: id.toString());
      await DatabaseHelper.insertAttendance(attendance);
    });
  }

  static Future<void> _uploadClassImages() async {
    List<AttendanceImage> images = await DatabaseHelper.fetchAttendanceImages();
    images.forEach((image) async {
      List<String> urls = await _scheduleRepo.uploadPhoto(timeTableId: image.eventId, files: [File(image.path)]);
      LectureEventListModel? event = await DatabaseHelper.fetchEventById(image.eventId);
      if (event != null) {
        event.classPictures.addAll(urls);
        try {
          await DatabaseHelper.insertEvent(event);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      await DatabaseHelper.removeAttendanceImage(id: image.id);
    });
  }

  static Future<void> _uploadTakenAttendance() async {
    List<OfflineStudentAttendanceModel> unuploadedAttendance = await DatabaseHelper.fetchUnuploadedStudentAttendanceList();
    unuploadedAttendance.forEach((element) async {

      bool synced = false;
      if (element.isAttendanceTaken) {
        if (element.data.isNotEmpty) {
          await _attendanceRepo.editAttendance(attendance: element.data, isOffline: true);
          synced = true;
        }
      } else {
        await _attendanceRepo.submitAttendance(attendance: element.data, isOffline: true);
        synced = true;
      }

      if (synced) {
        await DatabaseHelper.markStudentAttendanceUploaded(eventId: element.eventId);
      }

    });
  }

  static Future<LectureEventModel> setLocalActionsList(LectureEventModel event, String origin) async {

    for (int i = 0; i < event.list.length; i++) {
      event.list[i] = await setLocalActions(event.list[i], origin);
    }

    return event;
  }

  // removes existing actions and adds fresh actions to the event.
  // ported from backend code, do not change any part of it.
  static Future<LectureEventListModel> setLocalActions(LectureEventListModel event, String origin) async {

    event = await _applyOfflineData(event);
    event.actions = [];

    DateTime lectureDate = _dateFormatLectureDate.parse(event.lectureDate);
    DateTime lectureSTime = _dateFormatLectureTime.parse(event.lectureStartTime!);
    DateTime lectureETime = _dateFormatLectureTime.parse(event.lectureEndTime!);

    DateTime sTime = DateTime(lectureDate.year, lectureDate.month, lectureDate.day, lectureSTime.hour, lectureSTime.minute, lectureSTime.second);
    DateTime eTime = DateTime(lectureDate.year, lectureDate.month, lectureDate.day, lectureETime.hour, lectureETime.minute, lectureETime.second);

    double startTime = sTime.millisecondsSinceEpoch / 1000;
    double lectureStartTime = startTime - (45 * 60);
    double lectureEndTime = eTime.millisecondsSinceEpoch / 1000;
    double currentTime = DateTime.now().millisecondsSinceEpoch / 1000;

    if (event.zoomUrl != null) {
      Uri uri = Uri.parse(event.zoomUrl!);
      Map<String, String> params = uri.queryParameters;
      if (!params.containsKey('app_action')) {
        params['app_action'] = 'browser';
      }
      uri = uri.replace(queryParameters: params);
    }

    if (event.classType == '1') {
      if (event.eventType == 'extra_curricular') {
        // checking if interested is mandatory in this event.
        var action = {
          // 'between': SSNavigation(type: SSNavigationType.primary, title: 'Join Now', deeplink: 'hub:markLectureAndJoin', iconIdentifier: null),
          'between': SSNavigation(type: SSNavigationType.primary, title: 'Join Now', deeplink: 'hub:editAttendance', iconIdentifier: null),
          'after': SSNavigation(type: SSNavigationType.primary, title: 'Edit Attendance', deeplink: 'hub:editAttendance', iconIdentifier: null),
        };
        if ((lectureStartTime <= currentTime) && (currentTime <= lectureEndTime)) {
          event.actions!.add(action['between']!);
        } else if (lectureEndTime < currentTime) {
          event.actions!.add(action['after']!);
        }
      } else {
        var action = {
          // 'between': SSNavigation(type: SSNavigationType.primary, title: 'Join Now', deeplink: 'hub:markLectureAndJoin', iconIdentifier: null),
          'between': SSNavigation(type: SSNavigationType.primary, title: 'Join Now', deeplink: 'hub:editAttendance', iconIdentifier: null),
          'after': SSNavigation(type: SSNavigationType.primary, title: 'Edit Attendance', deeplink: 'hub:editAttendance', iconIdentifier: null),
        };
        if ((lectureStartTime <= currentTime) && (currentTime <= lectureEndTime)) {
          event.actions!.add(action['between']!);
        } else if (lectureEndTime < currentTime) {
          event.actions!.add(action['after']!);
        }
      }
    } else if (event.eventType != 'exam' && event.classType == '2') {

      lectureStartTime = startTime - (10 * 60);
      lectureEndTime = lectureEndTime + (10 * 60);

      if (event.isAttendanceTaken) {
        var action = {
          'between': SSNavigation(type: SSNavigationType.primary, title: 'Edit Attendance', deeplink: 'hub:editAttendance', iconIdentifier: null),
          'after': SSNavigation(type: SSNavigationType.primary, title: 'Edit Attendance', deeplink: 'hub:editAttendance', iconIdentifier: null),
        };

        if ((lectureStartTime <= currentTime) && (currentTime <= lectureEndTime)) {
          event.actions!.add(action['between']!);
        } else if (lectureEndTime < currentTime) {
          event.actions!.add(action['after']!);
        }
      } else {
        var action = {
          // 'between': SSNavigation(type: SSNavigationType.primary, title: 'Take Attendance', deeplink: 'hub:markLecture', iconIdentifier: null),
          'between': SSNavigation(type: SSNavigationType.primary, title: 'Take Attendance', deeplink: 'hub:takeAttendance', iconIdentifier: null),
          'after': SSNavigation(type: SSNavigationType.primary, title: 'Edit Attendance', deeplink: 'hub:editAttendance', iconIdentifier: null),
        };
        if ((lectureStartTime <= currentTime) && (currentTime <= lectureEndTime)) {
          event.actions!.add(action['between']!);
        } else if (lectureEndTime < currentTime) {
          event.actions!.add(action['after']!);
        }
      }

    }
    if (event.actions!.isEmpty) {
      if (origin == 'list') {
        event.actions!.add(
            SSNavigation(type: SSNavigationType.secondary, title: 'View Lecture Plan', iconIdentifier: null, deeplink: '${FlavorConfig.instance.variables[FlavourValueKeys.baseUrlWeb]}time-table/event/${event.id}')
        );

      } else {
        event.actions = [];
      }
    } else {
      if (origin == 'list') {
        event.actions!.add(
            SSNavigation(type: SSNavigationType.secondary, title: 'View Lecture Plan', iconIdentifier: null, deeplink: '${FlavorConfig.instance.variables[FlavourValueKeys.baseUrlWeb]}time-table/event/${event.id}')
        );

      }
    }

    return event;
  }

  static Future<LectureEventListModel> _applyOfflineData(LectureEventListModel event) async {

    OfflineStudentAttendanceModel? offlineData = await DatabaseHelper.fetchStudentAttendanceListById(eventId: event.id);
    if (offlineData == null) return event;
    event.isAttendanceTaken = true;

    return event;
  }

}