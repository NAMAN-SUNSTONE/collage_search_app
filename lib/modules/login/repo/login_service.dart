import 'package:admin_hub_app/constants/endpoints.dart';
import 'package:admin_hub_app/constants/error.dart';
import 'package:admin_hub_app/network/network.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:get/get.dart';
import 'package:ss_network/ss_network_client.dart';
import 'package:ss_network/ss_request.dart';
import 'package:ss_network/ss_response.dart';

class LoginService {
  static SSNetworkClient client = Get.find();

  static Future loginUserWithGoogleToken({required String token}) async {
    Map<String, dynamic> queryParams = {'token': token};

    SSNetworkRequest request = AppServiceFactory.getRequest(
        ApiEndpoints.loginUser, SSRequestType.post, AppBaseRequestType.base,
        queryParams: queryParams);

    SSNetworkResponse response = await client.makeRequest(request);
    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }

  static Future loginUserWithCredentials({required String email, required String password}) async {
    Map<String, dynamic> queryParams = {'email': email.trim(), 'password': password.trim()};

    SSNetworkRequest request = AppServiceFactory.getRequest(
        ApiEndpoints.loginUser, SSRequestType.post, AppBaseRequestType.base,
        queryParams: queryParams);

    SSNetworkResponse response = await client.makeRequest(request);
    if (response.error != null) {
      throw SSActionException(
          response.error?.errorMessage ?? ErrorMessages.unknown,
          response.error?.errorMessage ?? ErrorMessages.generic,
          response.error?.code ?? 0);
    }
    return response.data;
  }

}
