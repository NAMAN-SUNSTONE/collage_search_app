import 'package:admin_hub_app/constants/endpoints.dart';
import 'package:admin_hub_app/constants/error.dart';
import 'package:admin_hub_app/network/network.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:get/get.dart';
import 'package:ss_network/ss_network_client.dart';
import 'package:ss_network/ss_request.dart';
import 'package:ss_network/ss_response.dart';

class AttendanceService {
  static final SSNetworkClient _client = Get.find();

  static Future getAttendance(String timeTableId) async {
    Map<String, String> pathParams = {'id': timeTableId};

    SSNetworkRequest request = AppServiceFactory.getRequest(
        ApiEndpoints.attendanceDetails
      /*'v3/8499890d-289a-47fa-b37e-0e6180e9d831'*/,
        SSRequestType.get,
        AppBaseRequestType.base,
        pathParams: pathParams);

    SSNetworkResponse response = await _client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }

  static Future submitAttendance(List<Map<String, dynamic>> attendance, {bool isOffline = false}) async {
    Map<String, dynamic> query = {
      'attendance_data': attendance,
      'is_automated_attendance_lecture': 1,
      'is_offline': isOffline
    };

    SSNetworkRequest request = AppServiceFactory.getRequest(
        ApiEndpoints.markAttendance,
        SSRequestType.post,
        AppBaseRequestType.base,
        queryParams: query);

    SSNetworkResponse response = await _client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }

  static Future editAttendance(List<Map<String, dynamic>> attendance, {bool isOffline = false}) async {
    Map<String, dynamic> query = {
      'attendance_data': attendance,
      'is_automated_attendance_lecture': 1,
      'is_offline': isOffline
    };

    SSNetworkRequest request = AppServiceFactory.getRequest(
        ApiEndpoints.editAttendance,
        SSRequestType.post,
        AppBaseRequestType.base,
        queryParams: query);

    SSNetworkResponse response = await _client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }

  static Future resetAttendance(String eventId) async {
    Map<String, dynamic> query = {
      'event_id': eventId,
    };

    SSNetworkRequest request = AppServiceFactory.getRequest(
        ApiEndpoints.resetAttendance,
        SSRequestType.post,
        AppBaseRequestType.base,
        queryParams: query);

    SSNetworkResponse response = await _client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }

  static Future getAttendanceSubject(String? type, int? termNumber) async {
    Map<String, dynamic> query = {
      'type': type,
      'term_number': termNumber.toString()
    };

    SSNetworkRequest request = AppServiceFactory.getRequest(
        // 'v3/0ad8bec3-478f-4195-8ead-7c813eda4778',
        ApiEndpoints.attendanceSubjects,
        SSRequestType.get,
        AppBaseRequestType.base,
        /*queryParams: query*/);

    SSNetworkResponse response = await _client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }

  static Future fetchOfflineAttendanceData() async {

    SSNetworkRequest request = AppServiceFactory.getRequest(
      'v3/b6d366fe-b7d1-4866-8683-68a357b680a5',
      SSRequestType.get,
      AppBaseRequestType.mock);

    SSNetworkResponse response = await _client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }
}
