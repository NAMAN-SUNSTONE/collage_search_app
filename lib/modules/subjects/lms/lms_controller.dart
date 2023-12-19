import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/base/acdemic_content_repo.dart';
// import 'package:hub/academic_content/lms/lms_mock_repo.dart';
//
// import 'package:hub/academic_content/lms/lms_repo.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/ui/home/home_controller.dart';

import '../../../base/base_controller.dart';
import '../../../constants/enums.dart';
import '../../../theme/colors.dart';
import '../../attendance_report/model/academic_content_model.dart';
import '../../attendance_report/repo/acdemic_content_repo.dart';
import 'lms_repo.dart';

class LmsController extends BaseController {
  AcademicContentModel? academicContentData;
  String? errorMessage;

  // final HomeController? _homeController = Get.find<HomeController>();
  final AcademicContentRepo _repo = LmsRepo();

  final LmsParameters args = LmsParameters.fromJson(Get.parameters);

  ///holds the current selected tab
  Rx<int> selectedTab = 0.obs;

  @override
  void onInit() {
    fetchAcademicContent();
    super.onInit();
  }

  Future<void> fetchAcademicContent() async {
    status.value = Status.loading;

    try {
      academicContentData =
          await _repo.fetchAcademicContent(args.subjectId.toString());
      selectedTab.value = args.tabIdentifier.index;
      separateAssignmentModules();
      status.value = Status.success;
    } catch (e) {
      status.value = Status.error;
      errorMessage = e.toString();
    }
  }

  /// function called on tab switch
  /// Page start and stop events are called here
  onTabChange(int tab) {
    if (selectedTab.value == tab) {
      return;
    }

    // PageViewEvents.instance.beforeTabChange();
    selectedTab.value = tab;
    // PageViewEvents.instance.afterTabChange();
  }

  /// for analytics events
  String getCurrentTabPageName() {
    return 'lms_${LmsTabIdentifiers.values[selectedTab.value].name}';
  }

  Color get dynamicColor {
    return HubColor.iconColorCircle;
  }

  String? get courseType {
    return (academicContentData?.specializationId ?? -1) < 0
        ? 'Core'
        : 'Elective';
  }

  // String get subtitle {
    // String? semester = _homeController?.currentTerm?.label;
    // if (semester?.contains('semester') ?? false) {
    //   semester = semester?.replaceFirst('ester', '');
    // } else {
    //   semester = semester?.replaceFirst('mester', '');
    // }
    //
    // final updatedString =
    //     '${semester?.toUpperCase() ?? ''} ${(semester != null && courseType != null) ? '|' : ''} ${courseType ?? ''}';
    //
    // return updatedString;
  // }

  List<Module> assignmentModules = [];

  void separateAssignmentModules() {
    if (academicContentData?.modules != null)
      for (Module module in academicContentData!.modules) {
        Module filteredModule = new Module(
            contents: [], title: module.title, id: module.id, lectures: []);
        for (Content content in module.contents) {
          if ([ContentType.assignment, ContentType.quiz]
              .contains(content.academicType)) {
            filteredModule.contents.add(content);
          }
        }

        for (LectureModel lecture in module.lectures ?? []) {
          for (Content content in lecture.content) {
            if ([ContentType.assignment, ContentType.quiz]
                .contains(content.academicType)) {
              filteredModule.contents.add(content);
            }
          }
        }

        assignmentModules.add(filteredModule);
      }
  }
}

class LmsParameters {
  static final String subjectIdKey = 'subject_id';
  static final String tabIdentifierKey = 'tab_identifier';

  final int subjectId;
  final LmsTabIdentifiers tabIdentifier;

  LmsParameters({required this.subjectId, required this.tabIdentifier});

  factory LmsParameters.fromJson(Map<String, dynamic> json) {
    return LmsParameters(
      subjectId: int.tryParse(json[subjectIdKey].toString()) ?? -1,
      tabIdentifier: enumFromString(
          LmsTabIdentifiers.values, json[tabIdentifierKey] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      subjectIdKey: subjectId,
      tabIdentifierKey: tabIdentifier.toString().split('.').last
    };
  }
}

/// enum sequence should be same as tab sequence
enum LmsTabIdentifiers { info, modules, assignments, notes }
