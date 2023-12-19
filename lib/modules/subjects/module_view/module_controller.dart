import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../attendance_report/model/academic_content_model.dart';
import '../../attendance_report/repo/acdemic_content_repo.dart';
import '../lms/lms_repo.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/base/acdemic_content_repo.dart';
// import 'package:hub/academic_content/lms/lms_mock_repo.dart';
// import 'package:hub/academic_content/lms/lms_repo.dart';
// import 'package:hub/ui/base_controller.dart';

class ModuleViewArguments {
  final String title;
  final Module module;
  final List<ContentType> allowedContent;

  ModuleViewArguments({required this.module, required this.allowedContent, required this.title});
}

class ModuleViewParams {
  static const String subjectIdKey = 'subject_id';
  static const String moduleIdKey = 'module_id';
  static const String lectureIdKey = 'lecture_id';

  final int subjectId;
  final int moduleId;
  final int? lectureId;

  ModuleViewParams(
      {required this.subjectId, required this.moduleId, this.lectureId});

  factory ModuleViewParams.fromMap(Map<String, String?> maps) {
    return ModuleViewParams(
      subjectId: int.parse(maps[subjectIdKey]!),
      moduleId: int.parse(maps[moduleIdKey]!),
      lectureId: maps[lectureIdKey] != null
          ? int.tryParse(maps[lectureIdKey] ?? '')
          : null,
    );
  }

  Map<String, String> toJson() {
    return {
      subjectIdKey: subjectId.toString(),
      moduleIdKey: moduleId.toString(),
      if (lectureId != null) lectureIdKey: lectureId!.toString(),
    };
  }
}

class ModuleController extends BaseController with AppBarController {
  final AcademicContentRepo _repo = LmsRepo();
  late int moduleId;
  late int courseId;
  /// for focus on the lecture
  int? focusLectureId;
  List<ContentType> allowedContentType = ContentType.values;
  Module? module;
  String subTitle = "";
  String get title => module?.title ?? '';


  @override
  void onInit() async {
    super.onInit();

  }

  @override
  void onReady() async {
    super.onReady();
    _initialise();
    initScrollController();
  }

  _initialise() async {
    loading();
    try {
      final params = ModuleViewParams.fromMap(Get.parameters);

      courseId = params.subjectId;
      moduleId = params.moduleId;
      focusLectureId = params.lectureId;

      if (Get.arguments == null || Get.arguments is! ModuleViewArguments) {
        module = await _repo.fetchModuleDetails(
            courseId: courseId, moduleId: moduleId);
        subTitle = module?.subjectName ?? "";

      } else {
        final ModuleViewArguments args = Get.arguments;
        module = args.module;
        subTitle = args.title;
        allowedContentType = args.allowedContent;
      }
      success();
      _scrollToLecture();
    } catch (e) {
      failed();
    }
  }

  ///Scrolls to lecture tile if lecture id provided
  void _scrollToLecture(){
    if (focusLectureId != null && status.value == Status.success) {
      try {
        Future.delayed(Duration(milliseconds: 200), () {
          Scrollable.ensureVisible(
              GlobalObjectKey(focusLectureId!).currentContext!,
              duration: Duration(milliseconds: 500)
          );
        });
      } catch (e) {
        debugPrint("Error in scroll");
        debugPrint(e.toString());
      }
    }
  }
}

mixin AppBarController {
  final double kBasePadding = 36.0;
  final double kExpandedHeight = 122;
  ScrollController scrollController = ScrollController();
  RxDouble horizontalTitlePadding = 0.0.obs;
  bool showSubTitle = true;
  bool make1Liner = true;
  late final double _scrollableHt;

  initScrollController() {
    _scrollableHt = (kExpandedHeight - kToolbarHeight);
    scrollController.addListener(() => _setPadding());
  }

  _setPadding() {
    if (scrollController.hasClients) {
      if (scrollController.offset > _scrollableHt) {
        horizontalTitlePadding.value = kBasePadding;
      } else {
        horizontalTitlePadding.value =
            kBasePadding * scrollController.offset / _scrollableHt;
      }
    } else {
      horizontalTitlePadding.value = 0;
    }
    showSubTitle = scrollController.offset < 10;
    make1Liner = scrollController.offset < _scrollableHt - 20;
  }
}
