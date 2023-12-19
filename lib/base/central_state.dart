import 'package:admin_hub_app/analytics/utils/moengage.dart';
import 'package:admin_hub_app/modules/login/logout_sheet.dart';
import 'package:admin_hub_app/modules/login/model/user_model.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/utils/hub_storage.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class _CentralState {
  static _CentralState? _instance;
  _CentralState._internal();

  static _CentralState getInstance() {
    _instance ??= _CentralState._internal();
    return _instance!;
  }

  final HubStorage _storage = HubStorage.getInstance();

  String? get authToken => _storage.authToken;
  String? get userId => _storage.userId;
  String? get phone => _storage.phone;
  String? get email => _storage.email;

  bool get isUserLoggedIn => _storage.authToken != null;

  onLogin(UserModel user) {
    HubStorage.getInstance().userId = user.id;
    HubStorage.getInstance().authToken = user.token;
    HubStorage.getInstance().phone = user.phone;
    HubStorage.getInstance().email = user.email;
    initialiseUser();
  }

  ///initialise user here after login
  initialiseUser() {
    MoEngageUtils.setProfile(userId ?? '', email ?? '', phone ?? '');
  }

  void dispose() {
    _storage.authToken = null;
  }

  Future logoutAction() async {
    GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
    dispose();
    Get.offAllNamed(Paths.login);
  }

  Future onLogOut() async {
    MoEngageUtils.logout();
    showMyBottomModalSheet(
      Get.context!,
      ConfirmSheet(
        onYes: logoutAction,
        onNo: () {},
      ),
    );
  }
}

///global instance for app session
_CentralState centralState = _CentralState.getInstance();
