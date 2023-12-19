import 'package:admin_hub_app/generated/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/status_banner.dart';
// import 'package:hub/academic_content/content_view/content_view_controller.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/routes/page_navigator.dart';
// import 'package:hub/sunstone_base/widgets/snackbars_custom.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/base_controller.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';
import 'package:path/path.dart' as p;

import '../../../base/base_controller.dart';
import '../../../constants/enums.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/snackbars_custom.dart';
import '../../attendance_report/model/academic_content_model.dart';
import '../../content_view/assignments/widgets/status_banner.dart';
import '../../content_view/content_view_controller.dart';

class ContentList extends StatelessWidget {
  final int moduleId;
  final List<ContentType> allowedContentTypes;
  final List<Content>? contents;
  final int courseId;

  ContentList(
      {Key? key,
      required this.moduleId,
      required this.courseId,
      this.allowedContentTypes = ContentType.values,
      this.contents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<ChapterListController>(
          init: ChapterListController(
              moduleId: moduleId, courseId: courseId, contents: contents ?? []),
          global: false,
          builder: (controller) {
            return Obx(() {
              if (controller.status.value == Status.loading) {
                // return CupertinoActivityIndicator();
              }

              return ListView.separated(
                  itemCount: controller.getContents.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  separatorBuilder: (context, index) {
                    final content = controller.getContents[index];
                    if (allowedContentTypes.contains(content.academicType)) {
                      return Divider(
                        height: 1,
                        thickness: 1,
                        color: HubColor.purpleAccent2.withOpacity(0.2),
                        indent: 8,
                        endIndent: 8,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                  itemBuilder: (context, index) {
                    final Rx<Content> content =
                        controller.getContents[index].obs;

                    if (allowedContentTypes
                        .contains(content.value.academicType)) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: HubColor.purpleAccent2.withOpacity(0.5),
                          ),
                          color: HubColor.purpleAccent2.withOpacity(0.2),
                        ),
                        child: InkWell(onTap: () {
                          // if the content is quiz and status is overdue,
                          // we don't let the user to navigate
                          if (content.value.academicType ==
                              ContentType.quiz) {
                            SnackBarMessages.showErrorMessage(
                                'This feature is available on the web');
                          } else {
                            Get.toNamed(Paths.contentView, arguments: ContentViewArgs(
                                contents: contents ?? [],
                                onContentChange: (updatedContent) {
                                  content.value = updatedContent;
                                }), parameters: stringifyMap(ContentViewParams(
                              contentId: content.value.id,
                              moduleId: moduleId,
                              subjectId: courseId,
                            ).toJson()));
                          }
                        }, child: Obx(() {
                          return ContentItem(
                            contant: content.value,
                          );
                        })),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  });
            });
          }),
    );
  }
}

class ContentItem extends StatelessWidget {
  final Content contant;

  const ContentItem({Key? key, required this.contant}) : super(key: key);

  String get listItemIcon {
    switch (contant.academicType) {
      case ContentType.document:
        return getDocumentIconByType(contant.target!.redirectUrl);

      case ContentType.quiz:
        return Assets.svgQuiz;

      case ContentType.assignment:
        return Assets.svgAssignment;

      case ContentType.youtube_url:
        return Assets.svgPlayButtonSmall;

      default:
        return Assets.svgDoc;
    }
  }

  String getDocumentIconByType(String url) {
    final String extension = p.extension(url);

    switch (extension) {
      case '.pdf':
        return Assets.svgDoc;

      case '.mp4':
      case '.m3u8':
        return Assets.svgPlayButtonSmall;

      default:
        return Assets.svgDoc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 24,
              width: 24,
              child: Center(
                  child: SvgPicture.asset(
                listItemIcon,
                height: 24,
                width: 24,
              ))),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                contant.title ?? '',
                style: UIKitDefaultTypography().bodyText1.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                    overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
          // if (contant.assignment?.status != null)
          //   AssignmentStatusBadge(status: contant.assignment?.status),
          // if (contant.quiz?.status != null)
          //   AssignmentStatusBadge(status: contant.quiz?.status)
        ],
      ),
    );
  }
}

class ChapterListController extends BaseController {
  final int moduleId;
  final int courseId;
  final List<Content> contents;

  ChapterListController(
      {required this.moduleId, required this.courseId, required this.contents});

  List<Content> get getContents => contents;
}
