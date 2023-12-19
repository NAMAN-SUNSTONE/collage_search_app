import 'package:admin_hub_app/modules/login/model/user_model.dart';

abstract class LoginRepoBase {
  Future loginUserWithGoogleToken({required String token});
  Future<UserModel> loginUserWithCredentials({required String email, required String password});
}
