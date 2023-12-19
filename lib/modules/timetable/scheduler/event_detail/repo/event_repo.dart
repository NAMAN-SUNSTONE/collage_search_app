import 'dart:convert';

import 'package:admin_hub_app/constants/endpoints.dart';
import 'package:admin_hub_app/constants/error.dart';
import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/modules/calendar/ui/widgets/taught_lecture_list.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/offline/offline_utils.dart';
import 'package:admin_hub_app/network/network.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:admin_hub_app/network/ss_alert.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:get/get.dart';
// import 'package:hub/constants/constants.dart';
// import 'package:hub/data/student/models/lecture_model.dart';
// import 'package:hub/network/network.dart';
// import 'package:hub/network/ss_action_exception.dart';
import 'package:ss_network/ss_network_client.dart';
import 'package:ss_network/ss_request.dart';
import 'package:ss_network/ss_response.dart';
import 'package:http/http.dart' as http;

class EventRepo {

  Future<LectureEventListModel> getEventDetails({
    required int eventId,
    String? type
  }) async {

    bool isConnected = await ConnectivityManager.isOnline();
    if (!isConnected) {
      LectureEventListModel? event =
          await DatabaseHelper.fetchEventById(eventId);
      if (event != null) {
        event = await OfflineUtils.setLocalActions(event, 'detail');
        return event;
      } else {
        throw SSActionException(
            ErrorMessages.unknown, ErrorMessages.generic, 0);
      }
    }

    String updatedEndPoint = ApiEndpoints.eventDetails
        .replaceFirst('@EVENT_ID', eventId.toString());

    final Map<String, dynamic> queryParameters = {
      if (type != null) 'type': type
    };

    var request = AppServiceFactory.getRequest(
      updatedEndPoint
        /*'v3/b9c083c9-546a-44a8-94ad-2580b709bea2'*/, SSRequestType.get,
        AppBaseRequestType.base, queryParams: queryParameters);
    SSNetworkClient client = Get.find();
    SSNetworkResponse response = await client.makeRequest(request,);
    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    } else {
      return LectureEventListModel.fromJson(response.data);
    }
  }

  Future<SSAlert?> markLecture({
    required int eventId,
    String? type,
    required int lectureId,
    bool navigate = true
  }) async {
    String updatedEndPoint = ApiEndpoints.markLecture
        .replaceFirst('@EVENT_ID', eventId.toString());

    final Map<String, dynamic> params = {
      if (type != null) 'event_type': type,
      if (lectureId != TaughtLectureListController.notMentionedLecture.id) 'lecture_id': lectureId,
      'navigate': navigate
    };

    var request = AppServiceFactory.getRequest(
      updatedEndPoint
        /*'v3/8f29537d-18ca-41c7-bce9-12b83c638f28'*/, SSRequestType.put,
        AppBaseRequestType.base
        , queryParams: params);
    SSNetworkClient client = Get.find();
    SSNetworkResponse response = await client.makeRequest(request);
    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    } else {
      http.Response httpResponse = response.httpResponce as http.Response;

      Map<String, dynamic> respJson = json.decode(httpResponse.body);
      if (respJson['alert'] != null) {
        SSAlert alertModel = SSAlert.fromJson(respJson['alert']);
        return alertModel;
      } else
        return null;
    }
  }
}