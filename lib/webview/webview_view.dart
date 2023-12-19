import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/webview/webview_controller.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/data/student/models/target_model.dart';
// import 'package:hub/native_web_view/native_webview_helper.dart';
// import 'package:hub/routes/page_navigator.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/multiplatform.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/extensions.dart';
// import 'package:hub/utils/getx_extension.dart';
// import 'package:hub/utils/layout.dart';
// import 'package:hub/utils/navigator/navigator.dart';
// import 'package:hub/utils/web_operations.dart';
// import 'package:hub/widgets/app_bars/common_appbar.dart';
// import 'package:hub/widgets/back_buttons/back_button_bg_widget.dart';
import 'package:logger/logger.dart';

import '../../utils/flavour_variables.dart';

class WebViewView extends GetView<WebViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HubColor.white,
        body: SafeArea(
          child: HelpdeskMainView(),
        ));
  }
}

class HelpdeskMainView extends GetView<WebViewController> {
  @override
  Widget build(BuildContext context) {
    String? url = Get.parameters['url'];
    String title = Get.parameters['title'] ?? '';

    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              SHAppBar(title: title),
            Expanded(child: InAppWebView(
              key: controller.webViewKey,
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  safeBrowsingEnabled: true,
                  saveFormData: true,
                  useHybridComposition: true,
                  domStorageEnabled: true,

                  databaseEnabled: true,
                  clearSessionCache: true,
                  thirdPartyCookiesEnabled: true,
                  // allowUniversalAccessFromFileURLs: true,
                  allowFileAccess: true,
                  allowContentAccess: true,
                  // appCachePath: controller.appCachePath,
                ),
                ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
                crossPlatform: InAppWebViewOptions(
                  clearCache: true,
                  useShouldOverrideUrlLoading: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  cacheEnabled: true,
                  javaScriptEnabled: true,
                  mediaPlaybackRequiresUserGesture: false,
                  useShouldInterceptAjaxRequest: true,
                  useShouldInterceptFetchRequest: true,
                  useOnLoadResource: true,
                  useOnDownloadStart: true,
                ),
              ),
              onLoadStart: (controller, url) {
                controller.evaluateJavascript(
                    source:
                        '''window.SUNSTONE_ADMIN_WEBVIEW = window.flutter_inappwebview;''');
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                    resources: resources, action: PermissionRequestResponseAction.GRANT);
              },
              // shouldOverrideUrlLoading: (controller, navigationAction) async {
              //   var uri = navigationAction.request.url!;
              //   if (uri.scheme == 'whatsapp') {
              //     return NavigationActionPolicy.CANCEL;
              //   }
              //
              //   if (![
              //     "http",
              //     "https",
              //     "file",
              //     "chrome",
              //     "data",
              //     "javascript",
              //     "about",
              //   ].contains(uri.scheme)) {
              //     // debugPrint(navigationAction.request.url!.queryParameters
              //     //     .toString());
              //     String? phone = navigationAction.request.url!.queryParameters['phone'];
              //     String? msg = navigationAction.request.url!.queryParameters['text'];
              //
              //     String url = navigationAction.request.url!.toString();
              //
              //     // return NavigationActionPolicy.CANCEL;
              //     if (uri.scheme == 'whatsapp' && phone != null && phone.isNotEmpty) {
              //       phone = phone.trim();
              //       if (await canLaunch('https://wa.me/$phone?text=$msg')) {
              //         // Launch the App
              //         await launch(
              //           'https://wa.me/$phone?text=$msg',
              //         );
              //         // and cancel the request
              //         return NavigationActionPolicy.CANCEL;
              //       }
              //     } else if (await canLaunch(url)) {
              //       // Launch the App
              //       await launch(
              //         url,
              //       );
              //       // and cancel the request
              //       return NavigationActionPolicy.CANCEL;
              //     }
              //   }
              //   return NavigationActionPolicy.ALLOW;
              // },
              // onDownloadStartRequest: (InAppWebViewController controllerWeb,
              //     DownloadStartRequest? downloadStartRequest) {
              //   debugPrint(downloadStartRequest?.url.toString());
              //   SHNavigationManager.navigate(Target(
              //       identifier: Identifiers.browser,
              //       value: '',
              //       title: '',
              //       redirectUrl: downloadStartRequest!.url.toString()));
              // },
              initialUrlRequest: URLRequest(url: Uri.parse(url!)),
              onWebViewCreated: controller.onWebViewCreated,
            )),
          ],
        ),
        controller.status.value == Status.loading
            ? Center(child: CircularProgressIndicator())
            : Container(),
      ],
    );
  }
}
