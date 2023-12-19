import 'package:admin_hub_app/modules/subjects/lms/ui/lms_info.dart';
import 'package:admin_hub_app/modules/subjects/lms/ui/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/enums.dart';
import '../../../widgets/ss_appbar.dart';
import '../../../widgets/ss_loader.dart';
import '../../../widgets/tab_bar.dart';
import '../../attendance_report/model/academic_content_model.dart';

// import '../ui/saved_notes/notes_sections/notes_sections_view.dart';

import 'lms_controller.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/lms/lms_controller.dart';
// import 'package:hub/academic_content/lms/ui/lms_info.dart';
// import 'package:hub/academic_content/lms/ui/modules/modules.dart';
// import 'package:hub/constants/enums.dart';
//
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/ui/profile/attendance/subjects/data/saved_notes/tab_data.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/saved_notes/notes_sections/notes_sections_view.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/saved_notes/saved_notes_controller.dart';
// import 'package:hub/utils/layout.dart';
// import 'package:hub/widgets/tab_bar.dart';

class LmsView extends GetView<LmsController> {
  const LmsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.status.value == Status.loading ||
          controller.status.value == Status.init)
        return Scaffold(body: Center(child: LoaderWidget()));
      else if (controller.status.value == Status.success) {
        return Scaffold(
          body: _Body(),
          appBar: SHGradientAppBar(
            title: controller.academicContentData!.title,
            // subtitle: controller.subtitle,
          ),
        );
      }

      return ErrorScreen(
        error: controller.errorMessage ?? 'Something went wrong!',
      );
    });
  }
}

class _Body extends GetView<LmsController> {
  const _Body({Key? key}) : super(key: key);





  @override
  Widget build(BuildContext context) {
    final List<CustomTabObject> tabs =
      [
        // CustomTabObject(title: 'Info', child: LmsInfo()),
        if (controller.academicContentData!.modules.isNotEmpty)
          CustomTabObject(
            title: 'Modules',
            child: ModuleInfoView(
              key: ValueKey('modules'),
              modules: controller.academicContentData!.modules,
              courseId: controller.academicContentData!.id,
              subjectName:
              controller.academicContentData?.title ?? "",
            ),
          ),
        if (controller.academicContentData!.modules.isNotEmpty)
          CustomTabObject(
            title: 'Assignments & Quizzes',
            child: ModuleInfoView(
                modules: controller.assignmentModules,
                key: ValueKey('assignment&quizzes'),
                allowedContentTypes: [
                  ContentType.assignment,
                  ContentType.quiz
                ],
                courseId: controller.academicContentData!.id,
                subjectName:
                controller.academicContentData?.title ?? ""),
          ),
        // CustomTabObject(
        //     title: 'Notes',
        //     child: Expanded(
        //         child: NotesSections(
        //       savedNoteTabData:
        //           tabMappings[SavedNotesCategory.academic]![0],
        //       subjectId: controller.academicContentData!.id,
        //     ))),
      ];

    if(tabs.isEmpty){
      return Center(child: Text('No Details Found!'));
    }

    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Expanded(
          child: Obx(() {
            return CustomTabView1(
                selectedTab: controller.selectedTab.value,
                onTabChange: controller.onTabChange,
                selectedColor: controller.dynamicColor,
                tabs: tabs
              );
          }),
        ),
      ],
    );
  }
}
