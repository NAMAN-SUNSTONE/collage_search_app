import 'dart:developer';

import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/modules/login/model/user_model.dart';
import 'package:admin_hub_app/modules/login/repo/login_repo.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:admin_hub_app/widgets/ss_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:admin_hub_app/base/central_state.dart';

class LoginController extends BaseController {
  final LoginRepo _loginRepo = Get.find();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '100531486471-idchs9k6jk4gbqsoa6j919fb86n5cbob.apps.googleusercontent.com',
      serverClientId:
          '100531486471-fn78e4nmlid1pthod6bu6cq2qsucl1h1.apps.googleusercontent.com');
  String? _idToken;

  RxBool isLoading = false.obs;

  final loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey loginButtonKey = GlobalKey();

  final ScrollController scrollController = ScrollController();

  final shouldEnableLoginButton = false.obs;


  onLoginWithGoogleTap() async {
    isLoading.value = true;
    try {
      await signInWithGoogle();

      if (_idToken == null) {
        throw Exception('Failed to authenticate user');
      }
      final UserModel user = await _loginRepo.loginUserWithGoogleToken(token: _idToken!);
      _onLoginSuccess(user: user);
    } catch (e) {
      GoogleSignIn().disconnect();
      FirebaseAuth.instance.signOut();
      debugPrint(e.toString());
      showErrorMessage(e.toString());
    }
    isLoading.value = false;
  }

  void _onLoginSuccess({
    required UserModel user,
  }) {
    centralState.onLogin(user);
    //centralState.onLogin('5e76c39a-da06-4425-b9b3-3e1da592746c');
    Get.offNamed(Paths.dashboard);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception(
          "User not selected, please restart the app if this issue persists.");
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    _setIdToken(googleAuth?.idToken);
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _setIdToken(String? token) {
    _idToken = token;
  }

  void onLoginButtonTap() {
    loginFormKey.currentState?.save();
    if (loginFormKey.currentState?.validate() ?? false) {
      _onEmailAndPasswordLogin(
          email: emailController.text, password: passwordController.text);
    }
  }

  void _onEmailAndPasswordLogin(
      {required String email, required String password}) async {
    try {

      showOverlayLoader();
      final user = await _loginRepo.loginUserWithCredentials(
          email: email, password: password);
      closeOverlayLoader();
      _onLoginSuccess(user: user);
    } catch (e) {
      closeOverlayLoader();
      showErrorMessage(e.toString());

  }
}

  void onFormChanged() {
    final bool isValidEmail = emailController.text.isValidEmail();
    final bool isValidPassword = passwordController.text.isNotEmpty &&
        passwordController.text.length >= 4;

    if (isValidEmail && isValidPassword) {
      Scrollable.ensureVisible(loginButtonKey.currentContext!,
          duration: const Duration(milliseconds: 300),
         alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd
      );
      shouldEnableLoginButton.value = true;
    } else {
      shouldEnableLoginButton.value = false;
    }
  }

  @override
  void onClose() {
    passwordFocusNode.dispose();
    super.onClose();
  }
}
