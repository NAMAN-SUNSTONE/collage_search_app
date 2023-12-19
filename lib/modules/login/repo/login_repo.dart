import 'package:admin_hub_app/modules/login/model/user_model.dart';
import 'package:admin_hub_app/modules/login/repo/login_repo_base.dart';
import 'package:admin_hub_app/modules/login/repo/login_service.dart';

class LoginRepo implements LoginRepoBase {
  @override
  Future<UserModel> loginUserWithGoogleToken({required String token}) async {
    final response = await LoginService.loginUserWithGoogleToken(token: token);
    if (response['guid'] == null) {
      throw Exception('failed to access token');
    }

    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> loginUserWithCredentials(
      {required String email, required String password}) async {
    final result = await LoginService.loginUserWithCredentials(
        email: email, password: password);
    if (result != null && result is Map<String, dynamic> && result.isNotEmpty) {
      return UserModel.fromJson(result);
    }
    throw Exception('failed to login');
  }
}
