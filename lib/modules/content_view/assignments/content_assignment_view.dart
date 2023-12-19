import 'package:admin_hub_app/modules/content_view/assignments/widgets/status_banner.dart';
import 'package:admin_hub_app/modules/content_view/assignments/widgets/submitted_file_tile.dart';
import 'package:admin_hub_app/modules/content_view/assignments/widgets/uploadTile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/assignments/content_assignment_controller.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/status_banner.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/submitted_file_tile.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/uploadTile.dart';
// import 'package:hub/academic_content/content_view/widgets/back_next_button.dart';
// import 'package:hub/academic_content/content_view/widgets/download_content/download_content.dart';
// import 'package:hub/app_assets/app_image_path.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/sunstone_base/utils/background_downloader/background_downloader.dart';
// import 'package:hub/theme/colors.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../../generated/assets.dart';
import '../../../theme/colors.dart';
import '../../attendance_report/model/academic_content_model.dart';
import '../widgets/back_next_button.dart';
import '../widgets/download_content/download_content.dart';
import 'content_assignment_controller.dart';
// import 'content_assignment_controller.dart';

class ContentAssignmentView extends StatelessWidget {
  final Content content;
  final int subjectId;
  /// for re-fetching passed data, updating content assignment data
  final Function(LmsAssessmentModel)? onAssignmentUpdate;

  const ContentAssignmentView({Key? key, required this.content, required this.subjectId, this.onAssignmentUpdate })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContentAssignmentController>(
        init: ContentAssignmentController(assignmentContent: content, onAssignmentUpdate: onAssignmentUpdate,subjectId: subjectId),
        global: false,
        builder: (controller) {
          final assignment = controller.assignment;
          return WillPopScope(
            onWillPop: () {
              return controller.onExit();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (assignment.value != null)
                        Obx(() {
                          return AssignmentStatusBanner(
                              assignment: assignment.value!);
                        }),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          content.title,
                          style: UIKitDefaultTypography().headline5,
                        ),
                      ),

                      DownloadContentCard(content: controller.assignmentContent),

                      SizedBox(height: 16,),

                      // the heading 'your solution' will only be visible if status is not overdue
                      // if (controller.assignment.value?.status != AssignmentStatus.Overdue) Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: Text(
                      //     'Your solution',
                      //     style: UIKitDefaultTypography().headline5,
                      //   ),
                      // ),

                      // Obx(() {
                      //   return (controller.selectedFiles?.value.isNotEmpty ??
                      //           false)
                      //       ? Padding(
                      //           padding: const EdgeInsets.all(16.0),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               SizedBox(
                      //                 height: 16,
                      //               ),
                      //
                      //               Container(
                      //                 child: Column(
                      //                   children: [
                      //                     for (int localFileIndex = 0;
                      //                         localFileIndex <
                      //                             (controller.selectedFiles?.value
                      //                                     .length ??
                      //                                 0);
                      //                         localFileIndex++)
                      //                       Padding(
                      //                         padding: EdgeInsets.only(top: 16),
                      //                         child: UploadTile(
                      //                           index: localFileIndex,
                      //                           ssFile: controller.selectedFiles!
                      //                               .value[localFileIndex].ssFile,
                      //                           onUploadSuccess: (
                      //                               {required String url}) {
                      //                             controller.onFileUploadSuccess(
                      //                                 url, localFileIndex);
                      //                           },
                      //                           onDelete: () {
                      //                             controller.onFileRemove(
                      //                                 localFileIndex);
                      //                           },
                      //                         ),
                      //                       ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         )
                      //       : SizedBox.shrink();
                      // }),
                      // if (controller.assignment.value != null) ...[
                      //   Obx(() {
                      //     if ((controller.selectedFiles?.value.isEmpty ?? true) &&
                      //         (assignment.value!.attachments?.isNotEmpty ??
                      //             false))
                      //       return Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 16.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //
                      //
                      //             for (int i = 0;
                      //                 i < assignment.value!.attachments!.length;
                      //                 i++)
                      //               Padding(
                      //                 padding: EdgeInsets.only(top: 16),
                      //                 child: SizedBox(
                      //                   child: NetworkFileThumbnailPreviewer(
                      //                     url:
                      //                         assignment.value!.attachments![i],
                      //                     assessmentId: assignment?.value?.id,
                      //                   ),
                      //                 ),
                      //               )
                      //           ],
                      //         ),
                      //       );
                      //
                      //     return SizedBox.shrink();
                      //   }),
                      //   Obx(() {
                      //     return controller.shouldEnableUploadWidget
                      //         ? Padding(
                      //             padding: const EdgeInsets.all(16.0),
                      //             child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 InkWell(
                      //                   onTap: controller.onSelectFile,
                      //                   child: Container(
                      //                     height: 74,
                      //                     decoration: BoxDecoration(
                      //                       borderRadius:
                      //                           BorderRadius.circular(8),
                      //                     ),
                      //                     child: DottedBorder(
                      //                       radius: Radius.circular(32),
                      //                       color: HubColor.greyDC,
                      //                       child: Center(
                      //                         child: Row(
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.center,
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.center,
                      //                           children: [
                      //                             SvgPicture.asset(
                      //                                 Assets.svgUpload),
                      //                             SizedBox(
                      //                               width: 8,
                      //                             ),
                      //                             Obx(() {
                      //                               return Text(
                      //                                   controller
                      //                                       .uploadPlaceholderText,
                      //                                   style:
                      //                                       UIKitDefaultTypography()
                      //                                           .headline6
                      //                                           .copyWith(
                      //                                             color: HubColor
                      //                                                 .primary,
                      //                                             fontSize: 14,
                      //                                           ));
                      //                             }),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 SizedBox(height: 12),
                      //                 ...[
                      //                   'File size should be less than 10 MB',
                      //                   'File type should be JPG, PNG, PDF, DOCX, XLS, PPT'
                      //                 ]
                      //                     .map((text) => Text(text,
                      //                         style: UIKitDefaultTypography()
                      //                             .subtitle2
                      //                             .copyWith(
                      //                               color: HubColor.grey1
                      //                                   .withOpacity(.6),
                      //                             )))
                      //                     .toList(),
                      //               ],
                      //             ),
                      //           )
                      //         : SizedBox.shrink();
                      //   }),
                      //   SizedBox(
                      //     height: 70,
                      //   ),
                      // ],
                    ],
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Obx(() {
                //     if (controller.enableSubmitButton) {
                //       return Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: NextPrevButton(
                //           prevLabel: 'Discard',
                //           hideBack: false,
                //           nextLabel: 'Submit',
                //           onBackTap: () {
                //             controller.onDiscard();
                //           },
                //           onNextTap: () {
                //             controller.onSubmitAssignment();
                //           },
                //         ),
                //       );
                //     }
                //
                //     if (controller.isAssignmentAlreadySubmitted) {
                //       return Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: NextPrevButton(
                //               hideBack: false,
                //               hideNext: true,
                //               onBackTap: () {
                //                 controller.onResubmitAssignment();
                //               },
                //               prevLabel: 'Re-upload Assignment',
                //             ),
                //           ),
                //         ],
                //       );
                //     }
                //     return SizedBox.shrink();
                //   }),
                // )
              ],
            ),
          );
        });
  }
}
