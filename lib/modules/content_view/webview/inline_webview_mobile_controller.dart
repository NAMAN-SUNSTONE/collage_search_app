import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
// import 'package:hub/ui/base_controller.dart';

import '../../../base/base_controller.dart';

class InlineWebViewController extends BaseController {
  final String initialUrl;

  InlineWebViewController({required this.initialUrl});

  InAppWebViewController? webViewController;
  final loadingProgress = 0.0.obs;


   bool isInitialURl = true;

  @override
  void onInit() {
    super.onInit();
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
    webViewController?.loadUrl(
        urlRequest: URLRequest(url: Uri.parse(initialUrl)));
  }

  void onLoadStop(controller, uri) {
    isInitialURl = false;
  }

  void onProgressChange(controller, int progress) {
    loadingProgress.value = progress.toDouble() / 100;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
