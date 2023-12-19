import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/base/acdemic_content_repo.dart';
// import 'package:hub/constants/constants.dart';
// import 'package:hub/network/network.dart';
// import 'package:hub/network/ss_action_exception.dart';
import 'package:ss_network/ss_network_client.dart';
import 'package:ss_network/ss_request.dart';
import 'package:ss_network/ss_response.dart';

import '../../../constants/endpoints.dart';
import '../../../constants/error.dart';
import '../../../network/network.dart';
import '../../../network/ss_action_exception.dart';
import '../../attendance_report/model/academic_content_model.dart';
import '../../attendance_report/repo/acdemic_content_repo.dart';

class LmsRepo implements AcademicContentRepo {
  @override
  Future<AcademicContentModel> fetchAcademicContent(String courseId) async {
    var request = AppServiceFactory.getRequest(
      ApiEndpoints.courseDetails.replaceFirst('@courseId', courseId.toString()),
      // 'v3/5b6517eb-d5e6-4e21-8279-1f0b0b70c203',
      SSRequestType.get,
      AppBaseRequestType.base,
    );

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
  Future<Module> fetchModuleDetails(
      {required int moduleId, required int courseId}) async {
    final Map<String, dynamic> queryParams = {
      "courseId": courseId.toString(),
    };

    var request = AppServiceFactory.getRequest(
        ApiEndpoints.moduleData
            .replaceFirst('@moduleId', moduleId.toString()),
        SSRequestType.get,
        AppBaseRequestType.base,
     queryParams: queryParams
    );

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
