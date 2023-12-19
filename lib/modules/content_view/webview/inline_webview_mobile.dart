import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'inline_webview_mobile_controller.dart';
// import 'package:hub/academic_content/content_view/webview/inline_webview_mobile_controller.dart';
// import 'package:hub/academic_content/content_view/webview/inlineweview_web.dart';
// import 'package:hub/utils/web_view.dart';


typedef Future<NavigationActionPolicy?> ShouldOverrideUrlLoading(InAppWebViewController controller, NavigationAction navigationAction);

class InlineWebView extends StatelessWidget {
  final String initialUrl;
  final ShouldOverrideUrlLoading? shouldOverrideUrlLoading;


  const InlineWebView({Key? key, required this.initialUrl, this.shouldOverrideUrlLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InlineWebViewController>(
        init: InlineWebViewController(initialUrl: initialUrl),
        global: false,
        builder: (controller) {
          // if(controller.isWeb){
          //   return InlineWebViewWeb(url: initialUrl,);
          // }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return controller.loadingProgress.toInt() != 1
                    ? LinearProgressIndicator(
                        value: controller.loadingProgress.value,
                      )
                    : SizedBox.shrink();
              }),
              Expanded(
                child: InAppWebView(
                  onWebViewCreated: controller.onWebViewCreated,
                  onLoadStop: controller.onLoadStop,
                  onProgressChanged: controller.onProgressChange,
                  shouldOverrideUrlLoading: shouldOverrideUrlLoading ?? (controller, navigationAction) async {
                        // return WebViewUtils.shouldOverrideUrlLoading(
                        //     controller, navigationAction,
                        //     initialUrl: initialUrl);
                      },
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        supportZoom: true,
                        mediaPlaybackRequiresUserGesture: false,
                        useShouldOverrideUrlLoading: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      ),
                      ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true)),
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint(
                        'Inline player interface' + consoleMessage.message);
                  },
                ),
              ),
            ],
          );
        });
  }
}
