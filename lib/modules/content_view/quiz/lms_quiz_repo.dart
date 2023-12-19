import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
// import 'package:hub/academic_content/content_view/quiz/lms_quiz_data.dart';
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
import 'lms_quiz_data.dart';

class LmsQuizRepo {
  Future<LmsQuizSessionData> getSession({required String assessmentId}) async {
    Map<String, dynamic> body = {
      "assessment_id": assessmentId,
    };

    var request = AppServiceFactory.getRequest(
        ApiEndpoints.quizSession, SSRequestType.post, AppBaseRequestType.base,
        queryParams: body);

    SSNetworkClient client = Get.find();
    SSNetworkResponse response = await client.makeRequest(request);

    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    } else {
      return LmsQuizSessionData.fromJson(response.data);
    }
  }
}
