import 'package:admin_hub_app/analytics/events/screens/schedule.dart';
import 'package:admin_hub_app/deep_links/deep_links.dart';
import 'package:admin_hub_app/deep_links/page_navigator.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/utils/hub_storage.dart';
import 'package:admin_hub_app/widgets/ss_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/status_banner.dart';
// import 'package:hub/academic_content/content_view/content_view_controller.dart';
// import 'package:hub/academic_content/module_view/content_list.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/routes/page_navigator.dart';
// import 'package:hub/sunstone_base/widgets/snackbars_custom.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/theme/typography.dart';
// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/widgets/reusables.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';
import 'package:path/path.dart' as p;
import 'package:sunstone_ui_kit/ui_kit.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../utils/utils.dart';
import '../../../widgets/reusables.dart';
import '../../../widgets/snackbars_custom.dart';
import '../../attendance_report/model/academic_content_model.dart';
import '../../content_view/content_view_controller.dart';
import 'content_list.dart';

class LectureList extends StatelessWidget {
  final List<ContentType> allowedContentTypes;
  final List<LectureModel> lectures;
  final int courseId;
  final int moduleId;

  LectureList({
    Key? key,
    required this.moduleId,
    required this.courseId,
    required this.lectures,
    this.allowedContentTypes = ContentType.values,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (controller.getContents.isEmpty) {
    //   return Center(
    //     child: Column(
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             SvgPicture.asset(
    //               AppSvgPath.emptyContent,
    //               height: 24,
    //             ),
    //             SizedBox(
    //               width: 4,
    //             ),
    //             Text(
    //               "No Content uploaded yet!",
    //               style: UIKitDefaultTypography()
    //                   .bodyText2
    //                   .copyWith(color: HubColor.grey3),
    //             ),
    //           ],
    //         ),
    //         SizedBox(
    //           height: 16,
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return ListView.builder(
        itemCount: lectures.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          final LectureModel lecture = lectures[index];

          return LectureTile(
            lecture: lecture,
            courseId: courseId,
            moduleId: moduleId,
            allowedContentTypes: allowedContentTypes,
          );
        });
  }
}

class LectureTileController extends GetxController {
  final LectureModel lecture;
  final LectureEventListModel? event;

  LectureTileController(this.lecture, {this.event = null});

  final Map<ContentType, int> contentTypeCount = {};

  @override
  void onInit() {
    setContentMapWithType(lecture.content);
    super.onInit();
  }

  RxBool isExpanded = false.obs;

  onExpansion(bool val) {
    isExpanded.value = val;
  }

  void setContentMapWithType(List<Content> contents) {
    contents.forEach((content) {
      if (contentTypeCount.containsKey(content.academicType)) {
        contentTypeCount[content.academicType] =
            contentTypeCount[content.academicType]! + 1;
      } else {
        contentTypeCount[content.academicType] = 1;
      }
    });
  }

  String get title => lecture.title;
  String get getDescription {
    final int assignmentCount = contentTypeCount[ContentType.assignment] ?? 0;
    final int quizCount = contentTypeCount[ContentType.quiz] ?? 0;
    final int chapterCount =
        lecture.content.length - (assignmentCount + quizCount);

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
    return summaryParts.join(' | ');
  }

  void onTapHandbook() {
    if (event == null) return;
    SchedulePageEvents().openLectureHandbook(event!, lecture);
    SHPageNavigator.openWebView(lecture.handbookUrl!, title: 'Lecture handbook');
  }
}

class LectureTile extends StatelessWidget {
  final LectureEventListModel? event;
  final LectureModel lecture;
  final List<ContentType> allowedContentTypes;
  final int courseId;
  final int moduleId;
  final bool showDropDown;
  final Function(LectureModel)? onTapModuleCallback;
  const LectureTile(
      {Key? key,
        this.event,
      required this.lecture,
      required this.allowedContentTypes,
      required this.courseId,
      required this.moduleId,
      this.onTapModuleCallback,
      this.showDropDown = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LectureTileController>(
        init: LectureTileController(lecture, event: event),
        global: false,
        builder: (controller) {
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: HubColor.purpleAccent2.withOpacity(0.5),
                )),
            color: HubColor.purpleAccent2.withOpacity(0.2),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
                initiallyExpanded: showDropDown ? controller.isExpanded.value : true,
                onExpansionChanged: controller.onExpansion,
                //key: PageStorageKey('canvas_transition'),
                trailing: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: HubColor.grey1.withOpacity(0.1), width: 1),
                    shape: BoxShape.circle,
                  ),
                  child: Obx(() => Icon(
                        controller.isExpanded.value
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 26,
                        color: HubColor.grey1.withOpacity(0.7),
                      )),
                ),
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.title,
                              style: HubTypography.hubTextTheme.bodyText1
                                  ?.copyWith(
                                      color: HubColor.iconColorCircle,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0), maxLines: 2, overflow: TextOverflow.ellipsis),
                          Space(
                            height: 4,
                          ),
                          Text(controller.getDescription,
                              style: HubTypography.hubTextTheme.bodyText1
                                  ?.copyWith(
                                      color: HubColor.grey1.withOpacity(0.7),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.0)),
                        ],
                      ),
                    ),
                  ],
                ),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event != null && lecture.handbookUrl != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                      child: SSTile(
                          onTap: controller.onTapHandbook,
                          leading: SvgPicture.asset(Assets.svgIcHandbook, height: 16, width: 16),
                          title: 'Lecture handbook',
                          trailing: Container(
                            decoration: ShapeDecoration(
                              color: HubColor.chipColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              child: Text(
                                'New',
                                style: UIKitDefaultTypography().caption.copyWith(fontWeight: FontWeight.w600, color: HubColor.white),
                              ),
                            ),
                          )),
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
                    child: Material(
                        color: HubColor.white,
                        borderRadius: BorderRadius.circular(8),
                        child: ListView.separated(
                            shrinkWrap: true,padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: lecture.content.length,
                            itemBuilder: (bc, i) {
                              final Rx<Content> content =
                                  lecture.content[i].obs;

                              if (allowedContentTypes
                                  .contains(content.value.academicType)) {
                                return InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      // if the content is quiz and status is overdue,
                                      // we don't let the user to navigate
                                      if (content.value.academicType ==
                                              ContentType.quiz) {
                                        SnackBarMessages.showErrorMessage(
                                            'This feature is available on the web');
                                      } else {
                                        onTapModuleCallback?.call(lecture);
                                        Get.toNamed(
                                            Paths.contentView,
                                            arguments: ContentViewArgs(
                                                contents: lecture.content,
                                                onContentChange:
                                                    (updatedContent) {
                                                  content.value =
                                                      updatedContent;
                                                }),
                                            parameters:
                                                stringifyMap(ContentViewParams(
                                              contentId: content.value.id,
                                              moduleId: moduleId,
                                              subjectId: courseId,
                                            ).toJson()));
                                      }
                                    },
                                    child: Obx(() {
                                      return ContentItem(
                                        contant: content.value,
                                      );
                                    }));
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                            separatorBuilder: (bc, i) {
                              return Divider(
                                height: 1,
                                thickness: 1,
                                color: HubColor.purpleAccent2.withOpacity(0.2),
                                indent: 8,
                                endIndent: 8,
                              );
                            })),
                  ),
                ]),
          );
        });
  }
}
