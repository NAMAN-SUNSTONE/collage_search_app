import 'package:admin_hub_app/base/central_state.dart';
import 'package:admin_hub_app/constants/error.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:admin_hub_app/utils/build_info.dart';
import 'package:admin_hub_app/utils/flavour_variables.dart';
import 'package:admin_hub_app/utils/hub_storage.dart';
import 'package:ss_network/ss_request.dart';


enum AppBaseRequestType { base, mock, postmanMock }

enum RequestAuth { optional, mandatory }

class AppServiceFactory {
  static SSNetworkRequest getRequest(
      String endPoints, SSRequestType type, AppBaseRequestType baseRequestType,
      {Map<String, dynamic> queryParams = const {},
        Map<String, String> pathParams = const {}}) {
    var headers = _getHeaders(baseRequestType);
    var dataKey = _getDataKey(baseRequestType);
    var baseURL = _getBaseUrl(baseRequestType);
    SSNetworkRequest request = SSNetworkRequest(
        baseURL, headers, dataKey, endPoints, queryParams, pathParams, type);

    return request;
  }

  static SSNetworkRequest getOptionalRequest(
      String endPoints, SSRequestType type, AppBaseRequestType baseRequestType,
      {Map<String, dynamic> queryParams = const {},
        Map<String, String> pathParams = const {}}) {
    var headers = _getHeaders(baseRequestType);
    var dataKey = _getDataKey(baseRequestType);
    var baseURL = _getBaseUrl(baseRequestType);

    if (headers["Authorization"] == null) {
      throw SSActionException(
          ErrorMessages.authRequired, ErrorMessages.authRequired, 0,
          exceptionType: SSExceptionTypesEnums.silent);
    }

    SSNetworkRequest request = SSNetworkRequest(
        baseURL, headers, dataKey, endPoints, queryParams, pathParams, type);

    return request;
  }

  static Map<String, String> _getHeaders(AppBaseRequestType baseRequestType) {
    Map<String, String> headers = {
      'build-version': BuildInfo.buildVersion,
      'platform': BuildInfo.platform,
      'build-code': BuildInfo.buildNumber,
      'source':'admin_app'
    };

    // headers['Content-type'] = 'application/x-www-form-urlencoded';
    if (baseRequestType == SSRequestType.get) {
      headers['Content-type'] = 'application/x-www-form-urlencoded';
    } else {
      headers['Content-type'] = 'application/json';
      headers['Accept'] = 'application/json';
    }

    final bool isUserLoggedIn = centralState.isUserLoggedIn;

    headers['is_user_logged_in'] = isUserLoggedIn ? '1' : '0';

    final String? authToken = HubStorage.getInstance().authToken;
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    switch (baseRequestType) {
      case AppBaseRequestType.base:
        return headers;

      default:
        return headers;
    }
  }

  static String _getDataKey(AppBaseRequestType baseRequestType) {
    switch (baseRequestType) {
      case AppBaseRequestType.base:
        {
          return 'data';
        }
      default:
        {
          return 'data';
        }
    }
  }

  static String _getBaseUrl(AppBaseRequestType baseRequestType) {
    switch (baseRequestType) {
      case AppBaseRequestType.base:
        {
          return FlavourVariables.baseHubURL;
        }
      case AppBaseRequestType.mock:
        return 'https://run.mocky.io/';
        // return 'http://10.98.41.28:4001/';
      default:
        {
          return FlavourVariables.baseHubURL;
        }
    }
  }
}
