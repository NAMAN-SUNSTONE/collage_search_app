import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/exit_without_submit_popup.dart';
// import 'package:hub/academic_content/content_view/content_view_controller.dart';
// import 'package:hub/academic_content/content_view/quiz/lms_quiz_data.dart';
// import 'package:hub/academic_content/content_view/quiz/lms_quiz_repo.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/widgets/reusables.dart';

import '../../../base/base_controller.dart';
import '../../../constants/enums.dart';
import '../../../widgets/reusables.dart';
import '../../attendance_report/model/academic_content_model.dart';
import '../assignments/widgets/exit_without_submit_popup.dart';
import '../content_view_controller.dart';
import 'lms_quiz_data.dart';
import 'lms_quiz_repo.dart';

enum MindScrollQuizStatus {
  ///Loaded url state
  init,
  started,
  submitted
}

class LmsQuizController extends BaseController {
  /// Required to fetch the quiz session
  final Content assessmentContent;

  LmsQuizController({required this.assessmentContent});

  final quizRepo = Get.find<LmsQuizRepo>();

  LmsQuizSessionData? quizSessionData;

  String? errorMessage;

  MindScrollQuizStatus mindScrollQuizStatus = MindScrollQuizStatus.init;

  final contentViewController = Get.find<ContentViewController>();

  bool get hasQuizStarted =>
      mindScrollQuizStatus == MindScrollQuizStatus.started;

  bool get hasQuizSubmitted =>
      mindScrollQuizStatus == MindScrollQuizStatus.submitted;

  @override
  void onInit() {
    _fetchQuizSession();

    super.onInit();
  }

  Future<void> _fetchQuizSession() async {
    try {
      final String? assessmentId = assessmentContent.quiz?.id;

      if (assessmentId == null) {
        errorMessage = "Quiz id is empty";
        updateStatus(Status.error);
      }

      updateStatus(Status.loading);
      quizSessionData = await quizRepo.getSession(assessmentId: assessmentId!);
      if (quizSessionData?.sessionUrl != null &&
          (quizSessionData!.sessionUrl?.isNotEmpty ?? false)) {
        updateStatus(Status.success);
      }else{
        errorMessage = "Quiz session not found";
        updateStatus(Status.error);

      }
    } catch (e) {
      errorMessage = e.toString();
      updateStatus(Status.error);
    }
  }

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    final currentUri = navigationAction.request.url;

    bool isTestStarted = currentUri!.pathSegments.contains('startembed');
    bool isTestSubmitted = currentUri.pathSegments.contains('summary');

    if (isTestStarted) {
      mindScrollQuizStatus = MindScrollQuizStatus.started;
      contentViewController.forceHideNavigation(true);
    } else if (isTestSubmitted) {
      mindScrollQuizStatus = MindScrollQuizStatus.submitted;
      contentViewController.forceHideNavigation(false);
    } else {
      /// In case url changes to something else then we need to show the navigation
      contentViewController.forceHideNavigation(false);
    }

    return NavigationActionPolicy.ALLOW;
  }

  Future<bool> onWillPop() async {
    return onExit();
  }

  Future<bool> onExit() async {
    bool isCancel = false;
    if (hasQuizStarted && !hasQuizSubmitted) {
      showMyBottomModalSheet(
        Get.context!,
        ExitWithoutSubmit(
          onYes: () {
            isCancel = false;
          },
          onCancel: () {
            isCancel = true;
          },
          title: 'You haven’t completed quiz',
          description:
              'Any progress made on this quiz will be lost if you exit now. Are you sure you want to leave without submitting your answers?',
          yesText: 'Continue Submission',
          cancelText: 'Exit',
        ),
        title: 'Exit without submitting?',
      );
      return isCancel;
    } else {
      return true;
    }
  }
}
