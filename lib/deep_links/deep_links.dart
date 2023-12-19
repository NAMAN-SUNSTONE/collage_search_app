import 'dart:async';
import 'dart:developer';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:admin_hub_app/deep_links/mapped_data.dart';
import 'package:admin_hub_app/deep_links/page_navigator.dart';
import 'package:admin_hub_app/deep_links/patterns.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/utils/flavour_variables.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:admin_hub_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/app_manager/app_manger.dart';
// import 'package:hub/app_update/update_utils.dart';
// import 'package:hub/routes/page_navigator.dart';
// import 'package:hub/routes/universal_links/branch_payload_model.dart';
// import 'package:hub/routes/universal_links/constants.dart';
// import 'package:hub/routes/universal_links/patterns.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/multiplatform_io.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/ss_platform.dart';
// import 'package:hub/utils/extensions.dart';
// import 'package:hub/utils/flavour_variables.dart';
// import 'package:hub/utils/hub_storage.dart';
// import 'package:hub/utils/native_bridge.dart';
// import 'package:hub/utils/navigator/navigator.dart';
// import 'package:hub/utils/task_manager/states.dart';
// import 'package:hub/utils/task_manager/task.dart';
// import 'package:hub/utils/task_manager/task_manager.dart';
// import 'package:hub/utils/task_manager/task_type.dart';
import 'package:logger/logger.dart';
import 'package:ss_deeplink/models/pattern_mapper.dart';
import 'package:ss_deeplink/ss_base_deeplink_clinet.dart';
import 'package:ss_deeplink/ss_deeplink.dart';
import 'package:ss_deeplink/utils/deep_link_error.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:hub/payments/payments_manager.dart';
//
// import 'mapped_data.dart';

class UtmParametersBinding {
  final String pathName;
  final Map<String, String>? utmParameters;

  UtmParametersBinding({required this.pathName, required this.utmParameters});
}

class DeepLinks implements SSDeepLinkCallback {
  factory DeepLinks() {
    return _singleton ??= DeepLinks._internal();
  }

  DeepLinks._internal() {
    _dl = SSDeeplink();
  }

  static bool isAppOpenedFromFirebaseLink = false;

  static DeepLinks? _singleton;
  late SSDeeplink _dl;
  late StreamSubscription _sub;

  UtmParametersBinding? _utmParametersBinding;

  Map<String, String>? utmParameters;

  bool _hasDeferredDeepLinkAlreadyRegistered = false;

  //Constants
  static const String _firebaseDynamicLinkHost = 'sunstone.page.link';
  static const String typeformLinkHost = 'learnwithsunstone.typeform.com';
  final List<String> _patternSupportedHosts = [
    FlavourVariables.baseHubURL,
    FlavourVariables.webBaseUrl,
    typeformLinkHost,
    'https://class.sunstone.in/',
    'https://sunstone.in/',
    'https://dev-web.sunstone.in/'
  ];

  final List<String> _branchHosts = [
    'sunstone.app.link',
    'sunstone.test-app.link',
    'app.sunstone.in'
  ];

  Future init() async {
    _dl.configure(this);
    // _processInitialLink();
    // _checkFirstInstallParamsBranch();
    // if (!kIsWeb) {
    //   _startListening();
    // }

    // getInitialDeferredDeepLink();
  }

  static DeepLinks getInstance() {
    return _singleton ??= DeepLinks._internal();
  }

  @override
  List<SSDPatternMapperModel>? getPatternList() {
    return URLPatterns.patterns;
  }

  // void _checkFirstInstallParamsBranch() async {
  //   Map<dynamic, dynamic> branchLinkFirstInstallParams =
  //       await FlutterBranchSdk.getFirstReferringParams();
  //
  //   ///todo: remove after release testing
  //   AnalyticEvents.ddlTrackUrl(
  //       "branch : ${branchLinkFirstInstallParams.toString()}");
  //
  //   if (branchLinkFirstInstallParams.isNotEmpty) {
  //     _handleBranchPayload(branchLinkFirstInstallParams);
  //   }
  // }

  @override
  void onDeepLinkError(
      {SSDeepLinkError? error, String? link, dynamic extraData}) {
    if (error is SSDURLPatternNotMatchedError && link != null) {
      debugPrint("URL pattern not found");

      // Uri uri = Uri.parse(link);
      //
      // if (uri.host == typeformLinkHost) {
      //   SHPageNavigator.go(
      //       resource: DeepLinkResources.customWebViewNative, arguments: link);
      // } else {
      //   AppUpdateUtils.throwUpdateDialogue();
      // }
    } else {
      debugPrint("onDeepLinkError : $error");
    }
  }

  ///[id] -  first regex group element
  ///[data] - whole matched group including id element
  ///[extraData] - manually supplied extra data, deep link query params
  @override
  void recivedDeeplinkParams(
      String resource, String id, Map<String, dynamic> data,
      Map rawData,
      {dynamic extraData}) {
    MappedDeepLinkData _data = MappedDeepLinkData(
        id: id,
        resource: resource,
        data: data,
        rawData: rawData,
        extraData: extraData);

    utmParameters = extraData?['utm_parameters']?.cast<String, String>();
    if (utmParameters != null) {
      //Store UTM data for a screen load event
      _utmParametersBinding = UtmParametersBinding(
          pathName: _data.resource, utmParameters: utmParameters);
    }

    // final bool? isLoginRequiredParam =
    //     (extraData?['is_login_required'] as String?).toBool;
    //
    // if (isLoginRequiredParam == true) {
    //   if (!HubStorage.getInstance().isUserLoggedIn) {
    //     HubAppManager.getInstance().goToLogin(
    //         isPopPreviusScreenAll: false,
    //         onSuccessFullyLogined: () {
    //           _triggerDeepLinkAction(_data);
    //         });
    //   }
    //   return;
    // }

    // final bool shouldOpenWithoutLogin = [
    //       DeepLinkResources.customWebViewNative,
    //       DeepLinkResources.magicLink
    //     ].contains(_data.resource) ||
    //     (isLoginRequiredParam == false);
    //
    // if (shouldOpenWithoutLogin) {
    //   if (isDashboardPageLoaded ||isAppLaunched) {
    //     _triggerDeepLinkAction(_data);
    //   } else {
    //     SHTaskManager.instance.addTask(SHTask(
    //         taskType: SHTaskType.triggerDeepLinkAction,
    //         task: () {
    //           _triggerDeepLinkAction(_data);
    //         },
    //         triggerOnState: SHState.appLaunched));
    //   }
    // }
    // else if (isDashboardPageLoaded|| _data.resource == DeepLinkResources.login) {

      _triggerDeepLinkAction(_data);
    // } else {
    //   if (_data.resource == DeepLinkResources.loginWithUrl) {
    //     //in-case user login link found
    //     return _triggerDeepLinkAction(_data);
    //   } else {
    //     _triggerDeepLinkActionAfterLogin(_data);
    //   }
    // }
  }

  // bool get isDashboardPageLoaded =>
  //     SHTaskManager.instance.isStatePresent(SHState.isDashboardPageLoaded);
  //
  // bool get isAppLaunched =>
  //     SHTaskManager.instance.isStatePresent(SHState.appLaunched);

  void register(String link) {
    _registerDeepLink(link);
  }

  void registerWithExtraData(String? link, extraData) {
    debugPrint(link);
    if (link == null) return;
    _dl.registerDeepLink(uri: Uri.parse(link), extraData: extraData);
  }

  // Future<void> getInitialDeferredDeepLink() async {
  //   final String? url = await NativeBridge.getInitialDeferredDeepLink();
  //   if (url != null) {
  //     registerDeferredDeeplink(url);
  //   }
  // }

  void registerDeferredDeeplink(String? link) {
    //Todo://release test code -  remove if version  > 3.21.0
    // Only for testing purpose as its is not possible to test, only testable with real google app install campaign.
    // extra delay as analytics init might take time.
    // Future.delayed(Duration(seconds: 7), () {
    //   AnalyticEvents.ddlTrackUrl(link ?? 'null');
    // });

    try {
      if (link == null && link!.isEmpty) return;
      if (!_hasDeferredDeepLinkAlreadyRegistered) {
        _registerDeepLink(link);
        _hasDeferredDeepLinkAlreadyRegistered = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// handles the dynamic link and deep link when app is in killed state.
  // void _processInitialLink() async {
  //   // Commented for Testing the Dynamic Link Firebase.
  //   //  _handleInitialDynamicLinkOnIos();
  //
  //   //This Will Handle Initial Dynamic Link on All Platform  Android and IOS and WEB (Web Not Tested)
  //   FirebaseDynamicLinks.instance
  //       .getInitialLink()
  //       .then((PendingDynamicLinkData? data) async {
  //     //Handling Firebase Dynamic URL
  //     if (data != null) {
  //       isAppOpenedFromFirebaseLink = true;
  //       final Uri? deepLink = data.link;
  //       if (deepLink != null) {
  //         _registerDeepLink(deepLink.toString(),
  //             additionalUtm: data.utmParameters);
  //       }
  //     } else {
  //       // Handling Normal Deeplink URL
  //       try {
  //         String? _link = await getInitialLink();
  //         if (!shouldRegisterDeepLink(_link)) return;
  //
  //         _link = _sanitize(_link!);
  //         _registerDeepLink(_link);
  //       } on PlatformException {
  //         debugPrint('deep link failed');
  //       }
  //     }
  //   }).catchError((error) {
  //     debugPrint(error);
  //   });
  // }

  // void _startListening() {
  //   _listenDynamicLinkOnIOS();
  //
  //   _listenBranchLinks();
  //
  //   _listenUniLinks();
  // }

  /// for direct deep links, handles [foreground] state links
  // void _listenUniLinks() {
  //   //Dynamic link not working on iOS via UniLinks
  //   _sub = linkStream.listen((String? streamedLink) {
  //     if (!shouldRegisterDeepLink(streamedLink)) return;
  //
  //     isAppOpenedFromFirebaseLink = true;
  //
  //     // Extra safety to avoid listening dynamic link on iOS as it is already handled by _listenDynamicLinkOnIOS()
  //     if (_isDynamicHost(streamedLink!) && isIosPlatform) {
  //       return;
  //     }
  //
  //     if (_isBranchLink(streamedLink)) {
  //       return;
  //     }
  //
  //     if (PaymentsManager.nudge.value.blockingData != null &&
  //         PaymentsManager.nudge.value.blockingData!.isBlocked) return;
  //
  //     _registerDeepLink(streamedLink);
  //   }, onError: (err) {
  //     debugPrint(err);
  //   });
  // }

  /// branch links, handles [initial] state and [foreground] state links
  // void _listenBranchLinks() {
  //   debugPrint('_listenBranchLinks');
  //   // for debugging only
  //   // FlutterBranchSdk.validateSDKIntegration();
  //   StreamSubscription<Map> streamSubscription =
  //       FlutterBranchSdk.initSession().listen((data) {
  //     debugPrint("Branch link data : $data");
  //
  //     ///this stream also receives deep links from other source which are not branch links and handled by [linkStream]
  //     _handleBranchPayload(data);
  //   }, onError: (error) {
  //     debugPrint("Branch link error : $error");
  //   });
  // }
  //
  // void _handleBranchPayload(Map<dynamic, dynamic> data) {
  //   try {
  //     final branchPayload = BranchPayload.fromJson(data);
  //     final bool _isClickedBranchLink =
  //         data.containsKey("+clicked_branch_link") &&
  //             data["+clicked_branch_link"] == true;
  //
  //     if (_isClickedBranchLink) {
  //       if (branchPayload.deeplink != null) {
  //         _registerDeepLink(branchPayload.deeplink!,
  //             additionalUtm: branchPayload.getUtm);
  //       }
  //     } else {
  //       ///First time install campaign
  //       final bool hasUtmParams = branchPayload.getUtm.isNotEmpty;
  //       final bool hasDeepLink = branchPayload.deeplink != null;
  //
  //       if (hasDeepLink) {
  //         _registerDeepLink(branchPayload.deeplink,
  //             additionalUtm: branchPayload.getUtm);
  //         return;
  //       } else if (hasUtmParams) {
  //         /// Create a dummy deep link to track UTM params.
  //         setUtmForTheSession(branchPayload.getUtm);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
  //
  // /// handles [foreground] dynamic links on iOS
  // void _listenDynamicLinkOnIOS() {
  //   if (isIosPlatform) {
  //     FirebaseDynamicLinks.instance.onLink.listen((streamedDynamicLink) {
  //       debugPrint(
  //           'Received firebase dynamic link ->  ${streamedDynamicLink.link.toString()}');
  //       _registerDeepLink(streamedDynamicLink.link.toString(),
  //           additionalUtm: streamedDynamicLink.utmParameters);
  //     });
  //   }
  // }

  ///response Callback method -> [recivedDeeplinkParams] || [onDeepLinkError]
  /// [additionalUtm] is currently used only for iOS firebase dynamic link and branch utm as it does not provide utm parameters in the link
  void _registerDeepLink(String? link, {Map<String, String?>? additionalUtm}) {
    debugPrint('registering $link');

    if (!shouldRegisterDeepLink(link)) {
      return;
    }

    Uri linkURI = Uri.parse(link!);

    // // Firebase dynamic link
    // if (_isDynamicLink(linkURI.toString())) {
    //   _handleFirebaseDynamicLink(link);
    //   return;
    // }
    //
    // // Branch link
    // if (_isBranchLink(link!)) {
    //   _handleBranchLink(link);
    //   return;
    // }

    //Extracts UTM parameters from query
    final Map? deepLinkUtmParameters = extractUTMParameters(linkURI);

    Map _utmParameters = {
      ...linkURI.queryParameters,
      if (deepLinkUtmParameters != null || additionalUtm != null)
        "utm_parameters": {...?deepLinkUtmParameters, ...?additionalUtm}
    };

    registerWithExtraData(link, _utmParameters.isEmpty ? null : _utmParameters);
  }

  /// Extract utm parameters from the link
  Map? extractUTMParameters(Uri linkURI) {
    if (linkURI.queryParameters.isEmpty) {
      return null;
    }
    Map parameters = linkURI.queryParameters;
    Map<String, String> utmParameters = {
      if (parameters['utm_campaign'] != null)
        'utm_campaign': parameters['utm_campaign'],
      if (parameters['utm_medium'] != null)
        'utm_medium': parameters['utm_medium'],
      if (parameters['utm_source'] != null)
        'utm_source': parameters['utm_source'],
      if (parameters['utm_term'] != null) 'utm_term': parameters['utm_term'],
      if (parameters['utm_content'] != null)
        'utm_content': parameters['utm_content']
    };

    if (utmParameters.isEmpty) {
      return null;
    }
    return utmParameters;
  }

  /// decode the firebase dynamic link and register the deep link
  // void _handleFirebaseDynamicLink(String link) async {
  //   bool isDeepLinkRegistered = false;
  //   bool isLoaderVisible = false;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!isDeepLinkRegistered) {
  //       Get.dialog(SSLoader.light(child: SizedBox()));
  //       isLoaderVisible = true;
  //     }
  //   });
  //
  //   PendingDynamicLinkData? decodedData;
  //   try {
  //     decodedData =
  //         await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(link));
  //     debugPrint("Firebase dynamic link data : ${decodedData.toString()}");
  //     if (decodedData == null) return;
  //   } catch (e) {
  //     debugPrint("Firebase Dynamic link error : ${e.toString()}");
  //     return;
  //   } finally {
  //     if (Get.overlayContext != null && isLoaderVisible) {
  //       Navigator.of(Get.overlayContext!).pop();
  //     }
  //   }
  //
  //   Uri decodedLink = decodedData.link;
  //   final String host = "https://" + decodedLink.host + "/";
  //
  //   if (_patternSupportedHosts.contains(host)) {
  //     final Map<String, String?> utmParameters = decodedData.utmParameters;
  //     final Map<String, dynamic> extraDataPayload = {
  //       "utm_parameters": utmParameters
  //     };
  //     registerWithExtraData(decodedLink.toString(), extraDataPayload);
  //   } else {
  //     SHNavigationManager.openChromeSafari(decodedLink.toString());
  //   }
  //
  //   isDeepLinkRegistered = true;
  // }

  _triggerDeepLinkAction(MappedDeepLinkData mappedData) {
    String _id = mappedData.id;
    String? _url = mappedData.rawData["url"];
    String _resource = mappedData.resource;
    dynamic _extraData = mappedData.extraData;

    //Handling Deeplink for Custom Native WebView
    if (_resource == DeepLinkResources.customWebViewNative ||
        _resource == DeepLinkResources.magicLink) {
      if (_url != null) {
        _go(
            resource: _resource,
            arguments: _url,
            parameters: null,
            deepLink: _url,
            extraData: _extraData);
      }
      return;
    }

    var _formattedId = _formatId(_id);
    var arguments = mappedData.data.isNotEmpty ? mappedData.data : _formattedId;

    _go(
        resource: _resource,
        arguments: arguments,
        parameters: null,
        deepLink: _url,
        extraData: _extraData);
  }

  Map<String, String> getStringifyArgs(dynamic args) {
    if (args is Map) {
      return stringifyMap(args);
    } else {
      return {};
    }
  }

  void _go(
      {required String resource,
      required dynamic arguments,
      required Map<String, String>? parameters,
      required dynamic extraData,
      required String? deepLink}) {
    Map<String, String> parametersWithUtm = {...?parameters, ...?utmParameters};

    Map<String, String> stringifyArgs = getStringifyArgs(arguments);

    SHPageNavigator.go(
        resource: resource,
        arguments: arguments,
        parameters: {...?parametersWithUtm, ...stringifyArgs},
        extraData: extraData,
        deepLinkUri: deepLink != null ? Uri.parse(deepLink) : null);
  }

  // _triggerDeepLinkActionAfterLogin(MappedDeepLinkData _data) {
  //   SHTask _deepLinkActionTask = SHTask(
  //       taskType: SHTaskType.triggerDeepLinkAction,
  //       triggerOnState: SHState.isDashboardPageLoaded,
  //       task: () {
  //         _triggerDeepLinkAction(_data);
  //       });
  //   SHTaskManager.instance.addTask(_deepLinkActionTask);
  // }

  dynamic _formatId(String id) {
    if (id.isEmpty) {
      return null;
    }
    return int.tryParse(id) ?? id;
  }

  void dispose() async {
    await _sub.cancel();
    _singleton = null;
  }

  String _sanitize(String url) =>
      url.replaceFirst('/student', '').replaceFirst('/#', '');

  Map<String, String>? getUTMAndDelete(String path) {
    if (_utmParametersBinding == null) {
      return null;
    }
    if (path == _utmParametersBinding?.pathName) {
      final _utmParametersTemp = _utmParametersBinding?.utmParameters;
      //Commenting Below Line AS, Now We need UTM source Through Out The Session
      // _utmParametersBinding = null;
      return _utmParametersTemp;
    } else {
      return null;
    }
  }

  void setUtmForTheSession(Map<String, String> utmData) {
    Logger().log(Level.debug, utmData.toString());

    //Store UTM data for a screen load event
    if (!isAppOpenedFromFirebaseLink) {
      _utmParametersBinding = UtmParametersBinding(
          pathName: DeepLinkResources.blank, utmParameters: utmData);
    }
  }

  Map<String, String>? getSessionUTM() {
    final _utmParametersTemp = _utmParametersBinding?.utmParameters;

    return _utmParametersTemp;
  }

  // bool get isIosPlatform => SSPlatform.ios == getPlatform();

  bool _isDynamicHost(String url) {
    return url.contains(_firebaseDynamicLinkHost);
  }

  bool _isBranchLink(String url) {
    return _branchHosts.contains(Uri.parse(url).host);
  }

  bool _isDynamicLink(String url) {
    return Uri.parse(url).host == _firebaseDynamicLinkHost;
  }

  /// check if the link is a valid url or not
  bool shouldRegisterDeepLink(String? link) {
    if (link == null || link.isEmpty) {
      return false;
    }
    return (link.isValidUrl());
  }

  /// internally handle branch encoded link
  // void _handleBranchLink(String branchLink) {
  //   FlutterBranchSdk.handleDeepLink(branchLink);
  // }
}
