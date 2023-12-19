import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/ss_loader.dart';
import '../../attendance_report/model/academic_content_model.dart';
import '../assignments/widgets/status_banner.dart';
import '../webview/inline_webview_mobile.dart';
import 'lms_quiz_controller.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/status_banner.dart';
// import 'package:hub/academic_content/content_view/quiz/lms_quiz_controller.dart';
// import 'package:hub/academic_content/content_view/webview/inline_webview_mobile.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';

class LmsQuizView extends StatelessWidget {
  final Content assessmentContent;

  const LmsQuizView({Key? key, required this.assessmentContent});

  @override
  Widget build(BuildContext context) {
    // if quiz is overdue, simply show overdue UI
    if (assessmentContent.quiz?.status == AssignmentStatus.Overdue) {
      return OverdueStatusBanner(assignment: assessmentContent.quiz!);
    }
    return GetBuilder<LmsQuizController>(
        init: LmsQuizController(assessmentContent: assessmentContent),
        global: false,
        builder: (controller) {
          return Obx(() {
            return SSLoader.light(
                status: controller.status.value,
                hideChildWhileLoading: true,
                message: controller.errorMessage,
                child: controller.quizSessionData?.sessionUrl != null
                    ? WillPopScope(
                        onWillPop: controller.onWillPop,
                        child: InlineWebView(
                            initialUrl: controller.quizSessionData!.sessionUrl,
                            shouldOverrideUrlLoading:
                                controller.shouldOverrideUrlLoading),
                      )
                    : Text('No quiz found'));
          });
        });
  }
}
