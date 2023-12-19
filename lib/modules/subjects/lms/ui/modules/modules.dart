import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/module_view/content_list.dart';
// import 'package:hub/academic_content/module_view/module_controller.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/theme/colors.dart';
import 'package:sunstone_ui_kit/typo/ui_kit_default_typo.dart';

import '../../../../../constants/enums.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../theme/colors.dart';
import '../../../../../widgets/ss_loader.dart';
import '../../../../attendance_report/model/academic_content_model.dart';
import '../../../module_view/module_controller.dart';

class ModuleInfoView extends StatelessWidget {
  final Color color;
  final List<Module> modules;
  final List<ContentType> allowedContentTypes;
  final int courseId;
  final String subjectName;

  const ModuleInfoView(
      {Key? key,
      this.color = const Color(0xffB1A8CD),
      required this.modules,
      this.allowedContentTypes = ContentType.values,
      required this.courseId,
      required this.subjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SSLoader.light(
        status: modules.isEmpty ? Status.init : Status.success,
        message: modules.isEmpty ? "No modules found!" : null,
        // emptyStateSvgIcon: AppSvgPath.emptyContent,
        child: ListView.builder(
            itemCount: modules.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 0, left: 12, bottom: 12, right: 12),
            itemBuilder: (context, index) {
              return ExpandableModuleTile(
                module: modules[index],
                courseId: courseId,
                allowedContentTypes: allowedContentTypes,
                subjectName: subjectName,
              );
            }),
      ),
    );
  }
}

class ExpandableModuleTile extends StatelessWidget {
  final Color color;
  final Module module;
  final List<ContentType> allowedContentTypes;
  final int courseId;
  final String subjectName;

  ExpandableModuleTile(
      {Key? key,
      this.color = const Color(0xff0ffB1A8CD),
      required this.module,
      this.allowedContentTypes = ContentType.values,
      required this.courseId,
      required this.subjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpandableModuleTileController>(
        init: ExpandableModuleTileController(
            module: module,
            courseId: courseId,
            allowedContent: allowedContentTypes,
            subjectName: subjectName),
        global: false,
        builder: (controller) {
          return Column(
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ListTile(
                  onTap: controller.openModule,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: SvgPicture.asset(Assets.svgModule),
                  ),
                  trailing: Container(
                    padding: EdgeInsets.only(top: 4),
                    child: Column(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: HubColor.grey1.withOpacity(0.1),
                                width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 26,
                            color: HubColor.grey1.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    module.title ?? '',
                    style: UIKitDefaultTypography()
                        .bodyText1
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    maxLines: 2,
                  ),
                  subtitle: Text(controller.getDescription,
                      maxLines: 1,
                      style: UIKitDefaultTypography().bodyText1.copyWith(
                          fontSize: 12,
                          color: HubColor.grey1.withOpacity(0.4))),
                ),
              ),
              Divider(
                height: 16,
                color: color.withOpacity(.2),
                thickness: 1,
              ),
            ],
          );
        });
  }
}

class ExpandableModuleTileController extends GetxController {
  final Module module;
  final int courseId;
  final List<ContentType> allowedContent;
  final String subjectName;
  ExpandableModuleTileController(
      {required this.module,
      required this.courseId,
      required this.allowedContent,
      required this.subjectName});

  final Map<ContentType, int> contentTypeCount = {};

  List<Content> content = [];

  @override
  void onInit() {
    setContentMapWithType();
    super.onInit();
  }

  void openModule() {
    Get.toNamed(Paths.lmsModule,
        arguments:
        ModuleViewArguments(module: module, allowedContent: allowedContent, title: subjectName),
        parameters: ModuleViewParams(subjectId: courseId, moduleId: module.id)
            .toJson());
  }

  void setContentMapWithType() {
    for (LectureModel lecture in module.lectures ?? []) {
      for (Content lectureContent in lecture.content) {
        content.add(lectureContent);
      }
    }
    content.addAll(module.contents);

    content.forEach((content) {
      if (contentTypeCount.containsKey(content.academicType)) {
        contentTypeCount[content.academicType] =
            contentTypeCount[content.academicType]! + 1;
      } else {
        contentTypeCount[content.academicType] = 1;
      }
    });
  }

  String get getDescription {
    final int assignmentCount = contentTypeCount[ContentType.assignment] ?? 0;
    final int quizCount = contentTypeCount[ContentType.quiz] ?? 0;
    final int chapterCount = content.length - (assignmentCount + quizCount);

    final summaryParts = <String>[];
    if (chapterCount > 0) {
      summaryParts.add('$chapterCount Asset${chapterCount > 1 ? 's' : ''}');
    }
    if (assignmentCount > 0) {
      summaryParts
          .add('$assignmentCount Assignment${assignmentCount > 1 ? 's' : ''}');
    }
    if (quizCount > 0) {
      summaryParts.add('$quizCount Quiz${quizCount > 1 ? 'zes' : ''}');
    }
    return summaryParts.join(', ');
  }
}
