import 'package:admin_hub_app/modules/login/model/user_model.dart';
import 'package:admin_hub_app/modules/login/repo/login_repo_base.dart';

class LoginRepoMock implements LoginRepoBase {
  @override
  Future loginUserWithGoogleToken({required String token}) {

    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginUserWithCredentials({required String email, required String password}) {
    // TODO: implement loginUserWithCredentials
    throw UnimplementedError();
  }
}
