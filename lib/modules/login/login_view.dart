import 'package:admin_hub_app/widgets/buttons.dart';
import 'package:admin_hub_app/widgets/ss_loader.dart';
import 'package:admin_hub_app/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/login/login_controller.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/theme/size.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:lottie/lottie.dart';
import 'package:sunstone_ui_kit/typo/ui_kit_default_typo.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      controller: controller.scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                begin: FractionalOffset.bottomCenter,
                end: FractionalOffset.topCenter,
                colors: [
                  HubColor.primaryGradient,
                  HubColor.primary,
                ],
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SpaceLarge(
                    factor: 3,
                  ),
                  SvgPicture.asset(
                    Assets.authNamedLogo,
                    height: 45,
                  ),
                  const SpaceLarge(
                    factor: 2.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 14),
                    child: Image.asset(
                      Assets.imagesLoginBanner,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      Assets.authEyeGlass,
                      height: 80,
                    ),
                  ),
                ]),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: HubColor.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Educator',
                    style: UIKitDefaultTypography()
                        .headline4
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 20)),
                Text(
                  'Please log in to access your account',
                  style: UIKitDefaultTypography()
                      .bodyText1
                      .copyWith(color: UIKitColor.neutral3, fontSize: 14),
                ),
                SpaceLarge(
                  factor: 1.5,
                ),
                Form(
                  key: controller.loginFormKey,
                  onChanged: () {
                    controller.onFormChanged();
                  },
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: controller.emailController,
                        type: CustomTextFormFieldType.email,
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextFormField(
                        controller: controller.passwordController,
                        type: CustomTextFormFieldType.password,
                        placeholder: 'Password',
                        focusNode: controller.passwordFocusNode,
                        textInputAction: TextInputAction.go,
                        onActionTap: controller.onLoginButtonTap,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  key: controller.loginButtonKey,
                  width: double.infinity,
                  child: Obx(() {
                    return GeneralButton(
                      onPressed: controller.onLoginButtonTap,
                      buttonTextKey: 'Log in',
                      isEnabled: controller.shouldEnableLoginButton.value,
                    );
                  }),
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: UIKitColor.neutral1.withOpacity(0.2),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'OR',
                        style: UIKitDefaultTypography().subtitle1.copyWith(
                            fontSize: 12,
                            color: UIKitColor.neutral1.withOpacity(0.4)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: UIKitColor.neutral1.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlineButtonCustom(
                    onPressed: () {
                      controller.onLoginWithGoogleTap();
                    },
                    child: Text('Login with Sunstone Email'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
