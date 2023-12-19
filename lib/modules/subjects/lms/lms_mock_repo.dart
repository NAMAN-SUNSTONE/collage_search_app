import 'package:admin_hub_app/constants/error.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/attendance_report/repo/acdemic_content_repo.dart';
import 'package:admin_hub_app/network/network.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ss_network/ss_network_client.dart';
import 'package:ss_network/ss_request.dart';
import 'package:ss_network/ss_response.dart';

class LmsMockRepo extends AcademicContentRepo{
  @override
  Future<AcademicContentModel> fetchAcademicContent(String courseId) async {
    var request = AppServiceFactory.getRequest(
        'course/3265', SSRequestType.get, AppBaseRequestType.postmanMock);

    SSNetworkClient client = Get.find();
    SSNetworkResponse response = await client.makeRequest(request);
    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    } else {
      return AcademicContentModel.fromJson(response.data);
    }
  }

  @override
  Future<Module> fetchModuleDetails({required int moduleId, required int courseId}) async {
    var request = AppServiceFactory.getRequest(
        'courses/3265/modules/324', SSRequestType.get, AppBaseRequestType.postmanMock);

    SSNetworkClient client = Get.find();
    SSNetworkResponse response = await client.makeRequest(request);
    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    } else {
      return Module.fromJson(response.data);
    }
  }
}