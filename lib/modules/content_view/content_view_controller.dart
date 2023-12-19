import 'package:admin_hub_app/modules/content_view/widgets/three_dot_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constants/enums.dart';
import '../../constants/error.dart';
import '../../routes/app_pages.dart';
import '../attendance_report/model/academic_content_model.dart';
import '../subjects/lms/lms_repo.dart';

// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/content_view.dart';
// import 'package:hub/academic_content/content_view/widgets/three_dot_menu.dart';
// import 'package:hub/academic_content/lms/lms_repo.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/constants/constants.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/remote_config/remote_config_service.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/sunstone_base/utils/background_downloader/background_downloader.dart';

class ContentViewController extends FullLifeCycleController
    with FullLifeCycleMixin {
  late final ThreeDotMenuController menuController;

  Content? currentContent;

  final currentContentId = Rx<int?>(null);

  List<Content> contents = [];

  late PageController pageController;

  final currentPageIndex = 0.obs;

  final shouldEnableDownload = false.obs;

  Module? moduleDetails;

  final _repo = LmsRepo();

  String errorMessage = ErrorMessages.generic;

  LmsAssessmentModel? assignment;

  ///File type that app can open, for download button state
  List<String> downloadableFileTypes = [
    'pdf',
    'jpg',
    'png',
    'jpeg',
    'mp4',
    'avi'
  ];

  ///Hiding back and next button for override
  final hideNextButtonForce = false.obs;
  final hideBackButtonForce = false.obs;

  final title = ''.obs;
  ContentViewArgs? args;
  late ContentViewParams params;

  ///only show content widget
  final fullScreenMode = false.obs;
  bool fullScreenOnRotate = false;

  /// Content loading status
  final status = Status.init.obs;

  @override
  void onInit() async {
    super.onInit();
    menuController = ThreeDotMenuController(/*OverlayOptions()*/ SizedBox());
    params = ContentViewParams.fromJson(Get.parameters)!;

    if (Get.arguments is ContentViewArgs) {
      args = Get.arguments as ContentViewArgs?;
    }

    final contentInArgs = args?.contents;
    if (contentInArgs?.isNotEmpty ?? false) {
      updateStatus(Status.success);
      contents = args?.contents ?? [];
    } else if (args?.contents.isEmpty ?? true) {
      await fetchModuleDetails(
          moduleId: params.moduleId, courseId: params.subjectId);
    } else {
      updateStatus(Status.error);
    }

    if ((contents.isNotEmpty) && params.contentId != null) {
      currentPageIndex.value = contents
          .indexWhere((singleContent) => singleContent.id == params.contentId);
    }

    currentContent = contents[currentPageIndex.value];
    updateTitle();
    updateDownloadButtonState(contents[currentPageIndex.value]);
    pageController = PageController(initialPage: currentPageIndex.value);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  updateStatus(value) {
    status.value = value;
  }

  @override
  void onReady() {
    super.onReady();
  }

  void forceHideNavigation(bool flag) {
    hideNextButtonForce.value = flag;
    hideBackButtonForce.value = flag;
  }

  void updateDownloadButtonState(Content content) {
    final currentContent = this.contents[currentPageIndex.value];
    final String? redirectUrl = currentContent.target?.redirectUrl;

    final bool isNotDownloadableContentType = [
      ContentType.quiz,
      ContentType.assignment
    ].contains(currentContent.academicType);

    if (isNotDownloadableContentType) {
      shouldEnableDownload.value = false;
      return;
    }

    if (redirectUrl != null) {
      final String fileExtension = redirectUrl.split('.').last;

      final shouldShowDownloadButton =
          downloadableFileTypes.contains(fileExtension);

      shouldEnableDownload.value = shouldShowDownloadButton;
    } else {
      shouldEnableDownload.value = false;
    }
  }

  void updateTitle() {
    if (currentContent!.academicType == ContentType.assignment) {
      title.value = 'Your assignment';
    } else if (currentContent!.academicType == ContentType.document) {
      final fileType = currentContent!.target?.redirectUrl?.split('.').last;
      if (!['pdf', 'mp4', 'm3u8', 'avi'].contains(fileType)) {
        title.value = '';
      } else {
        title.value = currentContent!.title ?? '';
      }
    } else {
      title.value = currentContent!.title ?? '';
    }
  }

  void onPageChange(int index) {
    fullScreenMode.value = false;
    // PageViewEvents.instance.beforeTabChange();

    currentPageIndex.value = index;
    currentContent = contents[currentPageIndex.value];
    Future.delayed(Duration(milliseconds: 200), () {
      updateDownloadButtonState(currentContent!);
      updateTitle();
    });

    // PageViewEvents.instance.afterTabChange(additionalPageData: {
    //   'content_id': currentContent!.id.toString(),
    //   'content_type': currentContent!.academicType.toString().split('.').last,
    //   'content_title': currentContent!.title.toString(),
    // });
  }

  void onNextTap() {
    pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  void onBackTap() {
    pageController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  void onDownloadClick() async {
    final currentContent = contents[currentPageIndex.value];
    final String? redirectUrl = currentContent.target?.redirectUrl;

    if (shouldEnableDownload.value) {
      final String fileExtension = redirectUrl?.split('.').last ?? '';
      // AnalyticEvents.lmsDownloadContentClick(
      //   contentTitle: currentContent.title,
      //   fileType: fileExtension,
      //   contentType: currentContent.academicType.toString().split('.').last,
      // );
    }
  }

  ///gets the link from remote config
  ///and opens it in the help desk
  onReportClick() {
    // late final RemoteConfigService _remoteConfigService = Get.find();
    // final String url = _remoteConfigService.reportProblemContent;
    // Get.toNamed(Paths.helpDesk, parameters: {
    //   'url': url,
    //   ContentViewParams.subjectIdKey: params.subjectId.toString(),
    //   ContentViewParams.contentIdKey: params.contentId.toString()
    // });
  }

  @override
  void onClose() {
    menuController.close();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    super.onClose();
  }

  Future<void> fetchModuleDetails(
      {required int moduleId, required int courseId}) async {
    updateStatus(Status.loading);

    try {
      moduleDetails = await _repo.fetchModuleDetails(
          moduleId: moduleId, courseId: courseId);
      contents = moduleDetails?.contents ?? [];
    } catch (e) {
      debugPrint(e.toString());
      errorMessage = e.toString();
      updateStatus(Status.error);
      return;
    }

    debugPrint(moduleDetails?.contents?.length.toString());

    if (moduleDetails?.contents?.isEmpty ?? true) {
      updateStatus(Status.init);
    }
    updateStatus(Status.success);
  }

  String get pagePositionText {
    return "${currentPageIndex.value + 1}/${contents.length}";
  }

  void onOrientationChange(Orientation orientation) {
    if (fullScreenOnRotate) {
      if (orientation == Orientation.portrait) {
        fullScreenMode.value = false;
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
      } else {
        fullScreenMode.value = true;
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersive,
        );
      }
    }
  }

  @override
  void didChangeMetrics() {
    if (Get.context != null) {
      //In some devices orientation does updates quickly
      Future.delayed(Duration(milliseconds: 100),
          () => onOrientationChange(MediaQuery.of(Get.context!).orientation));
    }

    super.didChangeMetrics();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}

class ContentViewArgs {
  final List<Content> contents;
  final Function(Content)? onContentChange;

  ContentViewArgs({required this.contents, this.onContentChange});
}

class ContentViewParams {
  static const subjectIdKey = 'subject_id';
  static const moduleIdKey = 'module_id';
  static const contentIdKey = 'content_id';

  final int subjectId;
  final int moduleId;
  final int? contentId;

  ContentViewParams({
    required this.subjectId,
    required this.moduleId,
    this.contentId,
  });

  static ContentViewParams? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return ContentViewParams(
        subjectId: int.tryParse(json[subjectIdKey].toString()) ?? -1,
        moduleId: int.tryParse(json[moduleIdKey].toString()) ?? -1,
        contentId: int.tryParse(json[contentIdKey].toString()));
  }

  Map<String, dynamic> toJson() {
    return {
      subjectIdKey: subjectId,
      moduleIdKey: moduleId,
      contentIdKey: contentId,
    };
  }
}
