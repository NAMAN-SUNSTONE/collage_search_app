import 'package:admin_hub_app/modules/content_view/pdf/content_pdf_viewer.dart';
import 'package:admin_hub_app/modules/content_view/quiz/lms_quiz_view.dart';
import 'package:admin_hub_app/modules/content_view/video/ss_video_player.dart';
import 'package:admin_hub_app/modules/content_view/webview/inline_webview_mobile.dart';
import 'package:admin_hub_app/modules/content_view/widgets/back_next_button.dart';
import 'package:admin_hub_app/modules/content_view/widgets/three_dot_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/assignments/content_assignment_view.dart';
// import 'package:hub/academic_content/content_view/content_view_controller.dart';
// import 'package:hub/academic_content/content_view/generic_content/generic_content.dart';
// import 'package:hub/academic_content/content_view/image/image_viewer.dart';
// import 'package:hub/academic_content/content_view/pdf/content_pdf_viewer.dart';
// import 'package:hub/academic_content/content_view/quiz/lms_quiz_view.dart';
// import 'package:hub/academic_content/content_view/video/ss_video_player.dart';
// import 'package:hub/academic_content/content_view/webview/inline_webview_mobile.dart';
// import 'package:hub/academic_content/content_view/widgets/back_next_button.dart';
// import 'package:hub/academic_content/content_view/widgets/download_content/download_status.dart';
// import 'package:hub/academic_content/content_view/widgets/three_dot_menu.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/theme/typography.dart';
// import 'package:hub/widgets/reusables.dart';
import 'package:path/path.dart' as p;

import '../../constants/enums.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../widgets/reusables.dart';
import '../../widgets/ss_appbar.dart';
import '../../widgets/ss_loader.dart';
import '../attendance_report/model/academic_content_model.dart';
import 'assignments/content_assignment_view.dart';
import 'content_view_controller.dart';
import 'generic_content/generic_content.dart';
import 'image/image_viewer.dart';
import 'widgets/download_content/download_content_widget_wrapper.dart';

class ContentView extends GetView<ContentViewController> {
  const ContentView({Key? key}) : super(key: key);

  Widget? _getContentWidget(Content content) {
    final String? redirectUrl = content.target?.redirectUrl;
    controller.fullScreenOnRotate = false;
    switch (content.academicType) {
      case ContentType.document:
        return getPlayerByType(content);

      case ContentType.assignment:
        controller.fullScreenOnRotate = false;
        if (redirectUrl != null)
          return ContentAssignmentView(
            content: content,
            subjectId: controller.params.subjectId,
            onAssignmentUpdate: (assignmentData) {
              //finds updated assignment and update value
              controller.args?.contents.forEach((element) {
                if (content.id == element.id) {
                  content.assignment = assignmentData;
                  controller.args?.onContentChange?.call(content);
                }
                return;
              });
            },
          );
        break;

      case ContentType.quiz:
        return Center(child: Text('This feature is available on web'));

      case ContentType.web_view:
        controller.fullScreenOnRotate = true;
        if (redirectUrl != null)
          return InlineWebView(
            initialUrl: redirectUrl,
          );
        break;

      case ContentType.youtube_url:
        controller.fullScreenOnRotate = true;
        if (redirectUrl != null)
          return SSVideoPlayer(
            url: redirectUrl,
            title: content.title,
            key: Key(content.id.toString()),
          );

        break;
      default:
        return SizedBox.shrink();
    }

    return SizedBox.shrink();
  }

  Widget getPlayerByType(Content content) {
    final String? redirectUrl = content.target?.redirectUrl;
    final String extension = p.extension(redirectUrl!);
    controller.fullScreenOnRotate = false;
    switch (extension) {
      case '.pdf':
        controller.fullScreenOnRotate = true;
        return ContentPDFViewer(
          pdfDownloadUrl: redirectUrl,
          key: Key(content.id.toString()),
          id: content.id,
        );

      case '.mp4':
      case '.mov':
      case '.m3u8':
        return SSVideoPlayer(
          url: redirectUrl,
          title: content.title,
          key: Key(content.id.toString()),
          id: content.id,
        );

      case '.html':
      case '.htm':
        return InlineWebView(
          initialUrl: redirectUrl,
        );

      case '.jpg':
      case '.png':
      case '.jpeg':
        controller.fullScreenOnRotate = true;
        return SSImageViewerWidget(imageUrl: content.target!.redirectUrl);

      default:
        return GenericContent(content: content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContentViewController>(
        init: ContentViewController(),
        global: true,
        builder: (controller) {
          return Scaffold(body: Obx(() {
            return SSLoader.light(
              status: controller.status.value,
              // emptyStateSvgIcon: AppSvgPath.emptyContent,
              message: controller.errorMessage,
              child: controller.status.value == Status.success
                  ? Column(
                      children: [
                        !controller.fullScreenMode.value
                            ? SHAppBar(
                                // elevation: 3,
                                backgroundColor: HubColor.white,
                                title: controller.title.value,
                                actions: [
                                  if (controller.shouldEnableDownload.value)
                                    ThreeDotMenu(controller.menuController)
                                ],
                              )
                            : SizedBox(),
                        Expanded(
                          child: PageView.builder(
                            itemCount: controller.contents.length,
                            itemBuilder: (context, index) {
                              return _getContentWidget(
                                  controller.contents[index]);
                            },
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: controller.onPageChange,
                            controller: controller.pageController,
                          ),
                        ),
                        controller.fullScreenMode.value
                            ? SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8),
                                child: SafeArea(
                                  top: false,
                                  child: NextPrevButton(
                                    onNextTap: controller.onNextTap,
                                    onBackTap: controller.onBackTap,
                                    trailingText: controller.pagePositionText,
                                    hideBack:
                                        (controller.hideBackButtonForce.value ||
                                            controller.currentPageIndex == 0),
                                    hideNext:
                                        (controller.hideBackButtonForce.value ||
                                            controller.currentPageIndex ==
                                                controller.contents.length - 1),
                                  ),
                                ),
                              )
                      ],
                    )
                  : SizedBox.shrink(),
            );
          }));
        });
  }
}

class OverlayOptions extends GetView<ContentViewController> {
  const OverlayOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = EdgeInsets.all(12);
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ContentDownloadButton(
            padding: padding,
            content: controller.currentContent!,
            onDownloadClick: () {
              controller.onDownloadClick();
              controller.menuController.close();
            },
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: CustomDivider(
                height: 1,
                width: double.infinity,
              )),
          InkWell(
            onTap: () {
              controller.onReportClick();
              controller.menuController.close();
            },
            child: Padding(
              padding: padding,
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_outlined,
                    color: HubColor.grey1,
                  ),
                  SpaceHorizontal(
                    width: 8,
                  ),
                  Text(
                    "Report an issue",
                    style: HubTypography.hubTextTheme.bodyText1
                        ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
