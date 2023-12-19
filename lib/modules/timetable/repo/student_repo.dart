import 'package:admin_hub_app/constants/endpoints.dart';
import 'package:admin_hub_app/constants/error.dart';
import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';
import 'package:admin_hub_app/modules/calendar/data/calendar.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/offline/offline_utils.dart';
import 'package:admin_hub_app/modules/timetable/repo/student_repo_base.dart';
import 'package:admin_hub_app/network/network.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:admin_hub_app/utils/datetime_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ss_network/ss_network_client.dart';
import 'package:ss_network/ss_request.dart';
import 'package:ss_network/ss_response.dart';

class StudentRepo implements StudentRepoBase {

  final DateFormat _dayFormat = DateFormat('yyyy-MM-dd');

  @override
  Future<Calendar> fetchCalendarEvents({required DateTime offset, required int limit}) async {

    bool isConnected = await ConnectivityManager.isOnline();
    if (!isConnected) {
      List<LectureEventListModel> offlineEvents = await DatabaseHelper.fetchEvents(fromDate: offset, days: limit);
      String localTime = DateTime.now().toLocal().toServerFormat();
      LectureEventModel data = LectureEventModel(datetime: localTime, list: offlineEvents);
      data = await OfflineUtils.setLocalActionsList(data, 'list');
      return _parseCalendar(offset: offset, limit: limit, data: data);
    }

    Map<String, String> params = {};
    params['date'] = _dayFormat.format(offset);
    params['days'] = limit.toString();

    SSNetworkRequest request = AppServiceFactory.getRequest(ApiEndpoints.timeline/*'v3/9a0c871b-7525-4f9a-8066-645a0883ab12'*/, SSRequestType.get, AppBaseRequestType.base, queryParams: params);
    SSNetworkClient client = Get.find();

    SSNetworkResponse response = await client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    LectureEventModel data = LectureEventModel.fromJson(response.data);
    // await DatabaseHelper.clearEvents();
    data.list.forEach((event) {
      DatabaseHelper.insertEvent(event);
    });
    return _parseCalendar(offset: offset, limit: limit, data: data);
  }

  Calendar _parseCalendar({required DateTime offset, required int limit, required LectureEventModel data}) {

    Map<String, List<LectureEventListModel>> output = {};
    for (int day = 0; day < limit; day++) {
      DateTime date = offset.add(Duration(days: day));
      String dateKey = _dayFormat.format(date);
      output[dateKey] = [];
    }

    for (LectureEventListModel event in data.list) {
      output[event.lectureDate]?.add(event);
    }

    Calendar calendar = Calendar();
    calendar.serverTime = data.datetime;
    calendar.timeline = output;
    return calendar;

  }

  // Future<LectureEventListModel> _applyOfflineData(LectureEventListModel event) async {
  //
  //   OfflineStudentAttendanceModel? offlineData = await DatabaseHelper.fetchStudentAttendanceListById(eventId: event.id);
  //   if (offlineData != null) {
  //     event.isAttendanceTaken = offlineData.isAttendanceTaken || offlineData.uploaded;
  //     for (StudentModel student in attendance!.studentList) {
  //       for (StudentAttendanceModel studentAttendance in offlineData.data) {
  //         if (student.studentId == studentAttendance.studentId) {
  //           student.isPresent = studentAttendance.isPresent;
  //           break;
  //         }
  //       }
  //     }
  //   }
  //
  //   return event;
  //
  // }

}