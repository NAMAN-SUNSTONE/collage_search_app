import 'package:admin_hub_app/analytics/events/events.dart';
import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/webview/data/webview_model.dart';
import 'package:admin_hub_app/modules/content_view/content_view_controller.dart';
import 'package:admin_hub_app/utils/flavour_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/content_view/content_view_controller.dart';
// import 'package:hub/analytics/event_constants.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/constants/app_constants.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/constants/screen_names.dart';
// import 'package:hub/remote_config/remote_config_service.dart';
// import 'package:hub/routes/page_navigator.dart';
// import 'package:hub/routes/universal_links/constants.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/multiplatform.dart';
// import 'package:hub/native_web_view/models.dart';

// import 'package:hub/utils/flavour_variables.dart';
// import 'package:hub/utils/extensions.dart';
// import '../../analytics/event_constants.dart';
import '../../constants/enums.dart';
// import '../../constants/screen_names.dart';
import '../../utils/hub_storage.dart';
// import '../base_controller.dart';

class WebViewController extends BaseController {
  // Todo: Implement logic to get web url for Helpdesk
  // String get webUrlToLoad => HubStorage.getInstance().leadWebUrl ?? '';

  //This stack Does Not contains First Laod Url;
  RxList<String> iframeStack = <String>[].obs;

  InAppWebViewController? controllerWeb;

  Rx<bool> isDirectPop = false.obs;

  final GlobalKey webViewKey = GlobalKey();
  //Rx<bool> isLoading = true.obs;
  String? urlToLoad;

  Rx<NativeWebViewOptions?> options = Rx<NativeWebViewOptions?>(null);

  String appCachePath = '';

  late final String url;
  String? subjectId;
  String? contentId;

  @override
  void onInit() async {
    urlToLoad = Get.parameters['url'];

    // if (Get.arguments is NativeWebViewOptions) {
    //   options.value = Get.arguments as NativeWebViewOptions;
    //   options.refresh();
    // }

    // debugPrint('web url to load: $webUrlToLoad');

    // final Directory? extDir = await getExternalStorageDirectory();

    // appCachePath = extDir!.path + '/';

    // Todo: Ask Permission as and when needed
    // await Permission.camera.request();
    // await Permission.storage.request();
    // await Permission.photos.request();
    // await Permission.microphone.request();
    //Set The Stack List Empty On Every Init
    iframeStack.value = [];

    super.onInit();
    loading();
    final Map<String, String?> args = Get.parameters;

    String _url = args['url']!;
    success();
  }

  //On Web View Loaded
  void onWebViewLoaded(String finish) => success();

  //On Web View Created
  void onWebViewCreated(InAppWebViewController controller) {
    controllerWeb = controller;
    controller.addJavaScriptHandler(
        handlerName: NativeHandledActions.getUser, callback: _getUserData);
    success();
  }

  Map<String, dynamic> _getUserData(_) => HubStorage.getUserData();

  //Make sure this function return Future<bool> otherwise you will get an error
  Future<bool> onWillPop() async {
      if (controllerWeb != null) {
        final Uri? currentUri = await controllerWeb!.getUrl();
        if (url == currentUri?.toString()) {
          return true;
        }
        if (await controllerWeb!.canGoBack()) {
          controllerWeb?.goBack();
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }

  }
}
