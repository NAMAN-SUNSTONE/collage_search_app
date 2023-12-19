import 'dart:io';
import 'package:admin_hub_app/constants/endpoints.dart';
import 'package:admin_hub_app/constants/error.dart';
import 'package:admin_hub_app/network/network.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:get/get.dart';
import 'package:ss_network/ss_network_client.dart';
import 'package:ss_network/ss_request.dart';
import 'package:ss_network/ss_response.dart';

class ScheduleService {
  static final SSNetworkClient _client = Get.find();

  static Future getLectures() async {
    Map<String, dynamic> queryParams = {
      'list_type': 'pending',
      //'class_type': '2',
      'is_automated_attendance_lectures': '1'
    };

    SSNetworkRequest request = AppServiceFactory.getRequest(
        ApiEndpoints.lectures, SSRequestType.get, AppBaseRequestType.base,
        queryParams: queryParams);

    SSNetworkResponse response = await _client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }

  static Future<List<String>> uploadPhoto(
      {required timeTableId, required List<File> files}) async {
    var request = AppServiceFactory.getRequest(ApiEndpoints.uploadPhoto,
        SSRequestType.postMultipart, AppBaseRequestType.base,
        queryParams: {"time_table_id": timeTableId});
    if (files.isNotEmpty) {
      for (File x in files) {
        request.addFiles(SSNetworkFile('images', x));
      }
    }

    SSNetworkResponse response = await _client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data.cast<String>();
  }

  static Future setImageToEvent(String timeTableId, List<String> images) async {
    Map<String, dynamic> queryParams = {
      'time_table_id': timeTableId,
      'images': images
    };

    SSNetworkRequest request = AppServiceFactory.getRequest(
        ApiEndpoints.attendanceBroadcast,
        SSRequestType.post,
        AppBaseRequestType.base,
        queryParams: queryParams);
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
