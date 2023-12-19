import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

///
/// Wrap around any widget that makes an async call to show a modal progress
/// indicator while the async call is in progress.
///
/// The progress indicator can be turned on or off using [inAsyncCall]
///
/// The progress indicator defaults to a [CircularProgressIndicator] but can be
/// any kind of widget
///
/// The progress indicator can be positioned using [offset] otherwise it is
/// centered
///
/// The modal barrier can be dismissed using [dismissible]
///
/// The color of the modal barrier can be set using [color]
///
/// The opacity of the modal barrier can be set using [opacity]
///

class SSLoader extends StatelessWidget {
  final Status? status;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  late Widget? progressIndicator;
  final bool dismissible;
  final Widget child;
  final String? message;
  final LoaderType loaderType;
  final void Function()? onRetry;
  final bool hideChildWhileLoading;
  static const defaultOpacity = 0.7;

  SSLoader.light(
      {Key? key,
      this.inAsyncCall = true,
      this.status,
      this.opacity = defaultOpacity,
      this.color = HubColor.loaderBgLight,
      this.progressIndicator,
      this.dismissible = false,
      this.message,
      required this.child,
      this.loaderType = LoaderType.light,
        this.hideChildWhileLoading = false,
      this.onRetry})
      : super(key: key);

  SSLoader.dark(
      {Key? key,
      this.inAsyncCall = true,
      this.status,
      this.opacity = defaultOpacity,
      this.color = HubColor.loaderBgDark,
      this.message,
      this.progressIndicator,
      this.dismissible = false,
      required this.child,
      this.loaderType = LoaderType.dark,
        this.hideChildWhileLoading = false,
      this.onRetry})
      : super(key: key);

  Widget showLoader() {
    progressIndicator ??= Loader(type: loaderType, message: message);
    return hideChildWhileLoading ? SizedBox() : Center(child: progressIndicator);
  }

  @override
  Widget build(BuildContext context) {
    if (status != null) {
      if (status == Status.loading || status == Status.init) {
        return showLoader();
      }
      if (status == Status.success) return child;

      return ListView(
        children: [
          SizedBox(
            height: 200,
          ),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                color: HubColor.primary,
                size: 52,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Something went wrong!",
                style: TextStyle(
                  color: HubColor.primaryDark,
                ),
              ),
              if (onRetry != null) ...[
                Space(factor: 2),
                UIKitOutlineButton(text: "RETRY", onPressed: onRetry)
              ]
            ],
          )),
        ],
      );
    }

    //managing through inAsyncCall boolean
    if (!inAsyncCall) return child;

    return showLoader();
  }
}

class Loader extends StatelessWidget {
  final LoaderType type;
  final String? message;
  final Color? textColor;

  const Loader({required this.type, this.message, this.textColor});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
              type == LoaderType.light
                  ? Assets.lottieSsLoaderBlue
                  : Assets.lottieSsLoaderBlue,
              height: 80,
              width: 80),
          if (message != null)
            Text(
              message!,
              style: context.textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: textColor ?? HubColor.loaderBgLight,
              ),
            ),
        ],
      );
}

class LoaderWidget extends StatelessWidget {
  final LoaderType type;
  const LoaderWidget({this.type = LoaderType.light, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
        type == LoaderType.light
            ? Assets.lottieSsLoaderBlue
            : Assets.lottieSsLoaderWhite,
        height: 80,
        width: 80);
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({Key? key, this.error = 'Something went wrong!'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                color: HubColor.primary,
                size: 52,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                error,
                style: TextStyle(
                  color: HubColor.primaryDark,
                ),
              ),
            ],
          )),
    );
  }
}

enum LoaderType { light, dark }

void showOverlayLoader() {
  Get.dialog(
    Loader(
      type: LoaderType.light,
    ),
    barrierDismissible: false,
  );
}

void closeOverlayLoader() {
  Get.back(closeOverlays: true);
}