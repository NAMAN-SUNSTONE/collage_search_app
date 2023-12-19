import 'dart:convert';

import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/offline/attendance_image.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _dbName = 'sunstone_educator';
  static Database? _database;

  static const String _tableEvents = 'events';
  static const String _tableAttendance = 'attendance';
  static const String _tableAttendanceImages = 'attendance_images';
  static const String _tableStudentAttendance = 'student_attendance';

  static const String _createTableEvents =
      'create table $_tableEvents (id integer primary key autoincrement, event_id integer unique, time integer, data text)';
  static const String _createTableAttendance =
      'create table $_tableAttendance (id integer primary key autoincrement, event_id integer unique, data text)';
  static const String _createTableAttendanceImages =
      'create table $_tableAttendanceImages (id integer primary key autoincrement, event_id integer, path text)';
  static const String _createTableStudentAttendance = 'create table $_tableStudentAttendance (id integer primary key autoincrement, event_id integer unique, is_attendance_taken integer, data text, uploaded integer default 0)';

  static Future<void> setup() async {
    String dbPath = await getDatabasesPath();
    String path = '$dbPath/$_dbName';

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          _database = db;

          await execute(_createTableEvents);
          await execute(_createTableAttendance);
          await execute(_createTableAttendanceImages);
          await execute(_createTableStudentAttendance);
        });
  }

  static Future<void> execute(String query) async {
    await _database?.execute(query);
  }

  static Future<void> insertEvent(LectureEventListModel event) async {
    await _database?.transaction((txn) async =>
    await txn.rawInsert(
        'insert or replace into $_tableEvents (event_id, time, data) values (?, ?, ?)',
        [
          event.id,
          event.lectureDate
              .toDateTime(dateFormat: StringExt.yyyymmddFormat)
              .millisecondsSinceEpoch,
          jsonEncode(event)
        ]));
  }

  static Future<void> clearEvents() async {
    await _database?.transaction((txn) => txn.delete(_tableEvents));
  }

  static Future<LectureEventListModel?> fetchEventById(int id) async {
    LectureEventListModel? event;

    await _database?.transaction((txn) async {
      List<Map> result = await txn.rawQuery(
          'select data from $_tableEvents where event_id = $id limit 1');
      if (result.isNotEmpty) {
        event =
            LectureEventListModel.fromJson(jsonDecode(result.first['data']));
      }
    });

    return event;
  }

  static Future<List<LectureEventListModel>> fetchEvents(
      {required DateTime fromDate, required int days}) async {
    fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day, 0, 0, 0);
    DateTime toDate = fromDate.add(Duration(days: days + 1));
    List<LectureEventListModel> list = [];

    await _database?.transaction((txn) async {
      List<Map> result = await txn.rawQuery(
          'select data from $_tableEvents where time > ${fromDate
              .millisecondsSinceEpoch} and time < ${toDate
              .millisecondsSinceEpoch} order by time desc');
      result.forEach((entry) {
        LectureEventListModel event = LectureEventListModel.fromJson(
            jsonDecode(entry['data']));
        list.add(event);
      });
    });

    return list;
  }

  static Future<void> insertAttendance(AttendanceModel attendance) async {
    await _database?.transaction((txn) async =>
    await txn.rawInsert(
        'insert or replace into $_tableAttendance (event_id, data) values (?, ?)',
        [
          attendance.eventId,
          jsonEncode(attendance)
        ]));
  }

  static Future<AttendanceModel?> fetchAttendanceById(int id) async {
    AttendanceModel? attendance;

    await _database?.transaction((txn) async {
      List<Map> result = await txn.rawQuery(
          'select data from $_tableAttendance where event_id = $id limit 1');
      if (result.isNotEmpty) {
        attendance = AttendanceModel.fromJson(jsonDecode(result.first['data']));
      }
    });

    return attendance;
  }

  static Future<List<int>> fetchAttendanceMissingEvents() async {
    List<int> eventIds = [];

    await _database?.transaction((txn) async {
      List<Map> result = await txn.rawQuery(
          "select event_id from $_tableEvents where event_id not in (select event_id from $_tableAttendance)");
      if (result.isNotEmpty) {
        result.forEach((entry) {
          eventIds.add(entry['event_id']);
        });
      }
    });

    return eventIds;
  }

  static Future<void> insertAttendanceImage(
      {required int eventId, required String path}) async {
    await _database?.transaction((txn) async =>
    await txn.rawInsert(
        'insert into $_tableAttendanceImages (event_id, path) values (?, ?)',
        [eventId, path]));
  }

  static Future<List<String>> fetchAttendanceImagesByEventId(
      {required int eventId}) async {
    List<String> images = [];

    await _database?.transaction((txn) async {
      List<Map> result = await txn.rawQuery(
          'select path from $_tableAttendanceImages where event_id = $eventId');
      result.forEach((entry) {
        images.add(entry['path']);
      });
    });

    return images;
  }

  static Future<List<AttendanceImage>> fetchAttendanceImages() async {
    List<AttendanceImage> images = [];

    await _database?.transaction((txn) async {
      List<Map<String, dynamic>> result = await txn.rawQuery('select id, event_id, path from $_tableAttendanceImages');
      result.forEach((element) {
        images.add(AttendanceImage.fromJson(element));
      });
    });

    return images;
  }

  static Future<void> removeAttendanceImage({required int id}) async {
    await _database?.transaction((txn) async {
      await txn.rawDelete('delete from $_tableAttendanceImages where id = ?', [id]);
    });
  }

  static Future<void> saveStudentAttendanceList({required int eventId, required bool isAttendanceTaken, required List<StudentAttendanceModel> studentAttendance}) async {
    await _database?.transaction((txn) async {
      await txn.rawInsert('insert or replace into $_tableStudentAttendance (event_id, is_attendance_taken, data) values (?, ?, ?)', [
        eventId,
        isAttendanceTaken ? 1 : 0,
        jsonEncode(studentAttendance)
      ]);
    });

  }

  static Future<List<OfflineStudentAttendanceModel>> fetchUnuploadedStudentAttendanceList() async {

    List<OfflineStudentAttendanceModel> attendanceList = [];

    await _database?.transaction((txn) async {
      List<Map> result = await txn.rawQuery('select event_id, is_attendance_taken, uploaded, data from $_tableStudentAttendance where uploaded = 0');
      result.forEach((element) {
        int eventId = element['event_id'];
        bool isAttendanceTaken = element['is_attendance_taken'] == 1;
        bool uploaded = result.first['uploaded'] == 1;
        var jsonList = jsonDecode(jsonDecode(jsonEncode(element['data'])));
        List<StudentAttendanceModel> list = (jsonList as List).map((e) => StudentAttendanceModel.fromJson(e)).toList();
        attendanceList.add(OfflineStudentAttendanceModel(eventId: eventId, isAttendanceTaken: isAttendanceTaken, uploaded: uploaded, data: list));
      });
    });

    return attendanceList;
  }

  static Future<void> markStudentAttendanceUploaded({required int eventId}) async {

    await _database?.transaction((txn) async {
      await txn.rawUpdate('update $_tableStudentAttendance set uploaded = 1 where event_id = ?', [eventId]);
    });
  }

  static Future<OfflineStudentAttendanceModel?> fetchStudentAttendanceListById({required int eventId}) async {

    OfflineStudentAttendanceModel? data;

    await _database?.transaction((txn) async {
      List<Map> result = await txn.rawQuery('select event_id, is_attendance_taken, uploaded, data from $_tableStudentAttendance where event_id = $eventId limit 1');
      if (result.isNotEmpty) {
        int eventId = result.first['event_id'];
        bool isAttendanceTaken = result.first['is_attendance_taken'] == 1;
        bool uploaded = result.first['uploaded'] == 1;
        var jsonList = jsonDecode(jsonDecode(jsonEncode(result.first['data'])));
        List<StudentAttendanceModel> list = (jsonList as List).map((e) => StudentAttendanceModel.fromJson(e)).toList();
        data =  OfflineStudentAttendanceModel(eventId: eventId, isAttendanceTaken: isAttendanceTaken, uploaded: uploaded, data: list);
      }
    });

    return data;
  }
}
