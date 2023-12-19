import 'package:admin_hub_app/analytics/events/screens/schedule.dart';
import 'package:admin_hub_app/constants/constants.dart';
import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/deep_links/deep_links.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/content_view/ss_navigation.dart';
import 'package:admin_hub_app/modules/subjects/module_view/lecture_list.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/event_detail/widgets/class_detail_label.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/event_detail/widgets/single_row_text_widget.dart';

// import 'package:admin_hub_app/modules/timetable/scheduler/notes/view/notes_view.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/ss_action_factory.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:admin_hub_app/widgets/ss_loader.dart';
import 'package:admin_hub_app/widgets/view_image/view_image_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:hub/network/ss_action_exception.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

// import 'package:hub/analytics/events.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/beacon/beacon_attendance_controller.dart';
// import 'package:hub/constants/app_constants.dart';
// import 'package:hub/constants/constants.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/data/student/models/lecture_model.dart';
// import 'package:hub/data/student/models/target_model.dart';
// import 'package:hub/generated/assets.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/sunstone_base/data/ss_navigation.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_action_factory.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/preview_pdf/preview_pdf_controller.dart';
// import 'package:hub/ui/timetable/scheduler/event_detail/widgets/class_detail_label.dart';
// import 'package:hub/ui/timetable/scheduler/event_detail/widgets/single_row_text_widget.dart';
// import 'package:hub/ui/timetable/scheduler/notes/view/notes_view.dart';
// import 'package:hub/ui/timetable/scheduler/view_image/view_image_screen.dart';
// import 'package:hub/utils/navigator/navigator.dart';
// import 'package:hub/widgets/new_badge.dart';
// import 'package:hub/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import './event_detail_controller.dart';
import 'widgets/meeting_info_tile.dart';
import 'widgets/meeting_recordings.dart';
// import 'package:hub/utils/layout.dart';

class EventDetailView extends GetView<EventDetailController> {
  EventDetailView({Key? key});

  double _bannerHeight = 0;
  static const double _bottomSheetHeight = 76;
  late EventDetailController _controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventDetailController>(
        global: false,
        init: EventDetailController(),
        builder: (controller) {
          _controller = controller;
          return Scaffold(
              appBar: SHAppBar(title: 'Details'),
              body: Obx(() {
                LectureEventListModel? lectureData =
                    controller.lectureData.value;
                if (controller.eventDetailStatus == Status.error) {
                  return Center(
                    child:
                        Text(controller.errorMessage ?? 'Something went wrong'),
                  );
                }

                return SafeArea(
                  child: SSLoader.light(
                    inAsyncCall:
                        controller.eventDetailStatus.value == Status.loading,
                    child: controller.lectureData.value == null
                        ? SizedBox()
                        : Stack(
                            children: [
                              RefreshIndicator(
                                onRefresh: controller.onRefresh,
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Stack(
                                    children: [
                                      if (lectureData?.bannerURL != null)
                                        AspectRatio(
                                          aspectRatio: UIConstants
                                              .eventBannerAspectRatio,
                                          child: CachedNetworkImage(
                                            imageUrl: lectureData!.bannerURL!,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                      Column(
                                        children: [
                                          SizedBox(
                                            height:
                                                lectureData?.bannerURL != null
                                                    ? _bannerHeight
                                                    : 0,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: HubColor.backgroundColor2,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ClassDetailLabel(
                                                          lectureData:
                                                              controller
                                                                  .lectureData
                                                                  .value,
                                                          serverDateTime:
                                                              controller
                                                                  .serverDatTime
                                                                  .value,
                                                          deepLink: controller
                                                              .lectureData
                                                              .value
                                                              ?.metaData
                                                              .courseDeeplink),
                                                      SizedBox(
                                                        height: 24,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (controller
                                                        .lectureData
                                                        .value
                                                        ?.classRecordings
                                                        .isNotEmpty ??
                                                    false) ...[
                                                  Container(
                                                    child:
                                                        ClassRecordingsListView(
                                                      classRecordings: controller
                                                              .lectureData
                                                              .value
                                                              ?.classRecordings ??
                                                          [],
                                                      onPlayVideo:
                                                          (ClassRecordingModel
                                                              recording) {
                                                        controller.onPlayVideo(
                                                            recording);
                                                      },
                                                      eventType: controller
                                                          .lectureData
                                                          .value
                                                          ?.eventType,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 24,
                                                  ),
                                                ],
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (controller.onlineRoom
                                                                  .value !=
                                                              null &&
                                                          controller
                                                                  .onlineRoom
                                                                  .value
                                                                  ?.meetingID !=
                                                              null)
                                                        MeetingDetailsExpandableTile(
                                                          room: controller
                                                              .onlineRoom
                                                              .value!,
                                                        ),
                                                      if (controller
                                                          .lectureData
                                                          .value!
                                                          .professors
                                                          .isNotEmpty) ...[
                                                        SingelRowTextWidget(
                                                            svgIconPath: Assets
                                                                .svgMeetingHost,
                                                            value:
                                                                'By ${controller.professorNames}'),
                                                        SizedBox(height: 16),
                                                      ],
                                                      if (controller
                                                                  .lectureData
                                                                  .value
                                                                  ?.classType ==
                                                              '2' &&
                                                          controller
                                                                  .roomsNames !=
                                                              null) ...[
                                                        SingelRowTextWidget(
                                                            svgIconPath: Assets
                                                                .svgLocation,
                                                            value: controller
                                                                .roomsNames!),
                                                        SizedBox(height: 16),
                                                      ],
                                                      SingelRowTextWidget(
                                                        svgIconPath: Assets
                                                            .svgNotification,
                                                        value:
                                                            '10 minutes before',
                                                      ),
                                                      SizedBox(height: 16),
                                                      if (controller
                                                          .lectureData
                                                          .value!
                                                          .metaData
                                                          .attachment
                                                          .isNotEmpty) ...[
                                                        ...controller
                                                            .lectureData
                                                            .value!
                                                            .metaData
                                                            .attachment
                                                            .map(
                                                              (attachmentUrl) =>
                                                                  SingelRowTextWidget(
                                                                icon: Icons
                                                                    .attach_file,
                                                                value:
                                                                    'Attachment ${controller.lectureData.value!.metaData.attachment.indexOf(attachmentUrl) + 1}',
                                                                valueTextdecoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                isTextClickable:
                                                                    true,
                                                                onTap: () {
                                                                  launch(
                                                                      attachmentUrl);
                                                                },
                                                              ),
                                                            )
                                                            .toList(),
                                                        SizedBox(
                                                          height: 16,
                                                        )
                                                      ],
                                                      if ((controller
                                                              .lectureData
                                                              .value
                                                              ?.studentCount !=
                                                          null)) ...[
                                                        SingelRowTextWidget(
                                                          svgIconPath:
                                                              Assets.svgPeople,
                                                          value:
                                                              "${controller.lectureData.value?.studentCount} People",
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                        SizedBox(height: 16),
                                                      ],
                                                      if (controller
                                                          .lectureData
                                                          .value!
                                                          .metaData
                                                          .description
                                                          .isNotEmpty) ...[
                                                        SingelRowTextWidget(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          svgIconPath:
                                                              Assets.svgNotes,
                                                          value: controller
                                                              .lectureData
                                                              .value!
                                                              .metaData
                                                              .description,
                                                          textAlign:
                                                              TextAlign.justify,
                                                          enableHyperLink: true,
                                                        ),
                                                        SizedBox(height: 16),
                                                      ],
                                                      if (controller
                                                              .lectureData
                                                              .value!
                                                              .summary
                                                              .isNotEmpty &&
                                                          controller
                                                              .lectureData
                                                              .value!
                                                              .metaData
                                                              .description
                                                              .isEmpty) ...[
                                                        SingelRowTextWidget(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          svgIconPath:
                                                              Assets.svgNotes,
                                                          value: controller
                                                              .lectureData
                                                              .value!
                                                              .summary,
                                                          textAlign:
                                                              TextAlign.justify,
                                                          enableHyperLink: true,
                                                        ),
                                                        SizedBox(height: 24),
                                                      ],
                                                      if (_controller
                                                          .lectureData
                                                          .value!
                                                          .hasLecture) ...[
                                                        Text(
                                                          'Lecture',
                                                          style: UIKitDefaultTypography()
                                                              .subtitle1
                                                              .copyWith(
                                                                  color: HubColor
                                                                      .black),
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        LectureTile(
                                                          event: _controller.lectureData.value!,
                                                            showDropDown: false,
                                                            moduleId:
                                                                _controller
                                                                    .lectureData
                                                                    .value!
                                                                    .metaData
                                                                    .moduleId!,
                                                            courseId:
                                                                _controller
                                                                    .lectureData
                                                                    .value!
                                                                    .metaData
                                                                    .courseId!,
                                                            lecture: _controller
                                                                .lectureData
                                                                .value!
                                                                .metaData
                                                                .lecture!,
                                                            allowedContentTypes:
                                                                ContentType
                                                                    .values,
                                                            onTapModuleCallback:
                                                                (lecture) {
                                                              SchedulePageEvents()
                                                                  .openContent(
                                                                      controller
                                                                          .lectureData
                                                                          .value!,
                                                                      lecture);
                                                            }),
                                                        SizedBox(height: 24),
                                                      ],
                                                      // if (controller
                                                      //     .lectureData
                                                      //     .value!
                                                      //     .attachments
                                                      //     .isNotEmpty) ...[
                                                      //   Text(
                                                      //     'Attachments',
                                                      //     style: UIKitDefaultTypography()
                                                      //         .subtitle1
                                                      //         .copyWith(
                                                      //             color: HubColor
                                                      //                 .black),
                                                      //   ),
                                                      //   const SizedBox(
                                                      //     height: 16,
                                                      //   ),
                                                        // GridView.builder(
                                                        //     shrinkWrap: true,
                                                        //     padding:
                                                        //     EdgeInsets.zero,
                                                        //     physics:
                                                        //     NeverScrollableScrollPhysics(),
                                                        //     itemCount: controller
                                                        //         .lectureData
                                                        //         .value!
                                                        //         .attachments
                                                        //         .length,
                                                        //     gridDelegate:
                                                        //     SliverGridDelegateWithFixedCrossAxisCount(
                                                        //         crossAxisSpacing:
                                                        //         8,
                                                        //         mainAxisSpacing:
                                                        //         12,
                                                        //         crossAxisCount:
                                                        //         3),
                                                        //     itemBuilder: (context,
                                                        //         index) =>
                                                        //         ViewAttachment(
                                                        //           controller
                                                        //               .lectureData
                                                        //               .value!
                                                        //               .attachments[
                                                        //           index]
                                                        //               .url ??
                                                        //               '',
                                                        //           isLoading:
                                                        //           false,
                                                        //           disableDelete:
                                                        //           true,
                                                        //         )),
                                                      //   const SizedBox(
                                                      //     height: 16,
                                                      //   ),
                                                      // ],
                                                      // Obx(() => (controller
                                                      //     .note.value !=
                                                      //     null)
                                                      //     ? NotesPreview(
                                                      //   notes: controller
                                                      //       .note.value!,
                                                      //   onClick: () {
                                                      //     AnalyticEvents.noteMyNotesEvent(
                                                      //         controller
                                                      //             .subject,
                                                      //         controller
                                                      //             .note
                                                      //             .value
                                                      //             ?.title ??
                                                      //             '',
                                                      //         controller
                                                      //             .lectureStartTime);
                                                      //     controller
                                                      //         .onNoteClick();
                                                      //   },
                                                      // )
                                                      //     : Container()),
                                                      SizedBox(
                                                          height:
                                                              _bottomSheetHeight)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      //for bottom-sheet
                                      SizedBox(
                                        height: 74,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Obx(() => (controller.showNewTag.value &&
                              //     (controller.lectureData.value
                              //         ?.isToShowAddNotes ??
                              //         false))
                              //     ? Positioned(
                              //   right: 0,
                              //   top: 2,
                              //   child: Container(
                              //     child: NewTag(
                              //       notchAlignment: Alignment.topRight,
                              //       label: 'Personal Note Feature',
                              //     ),
                              //   ),
                              // )
                              //     : Container())
                            ],
                          ),
                  ),
                );
              }),
              bottomSheet: Obx(() {
                // if (controller.lectureData.value == null)
                //   return SizedBox();
                // if (controller.onlineRoom.value != null)
                //   return Container(
                //     height: _bottomSheetHeight,
                //     color: HubColor.white,
                //     child: Center(
                //       child: SizedBox(
                //         width: MediaQuery.of(context).size.width,
                //         child: Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: GeneralButton(
                //             buttonTextKey: 'Join',
                //             onPressed: () {
                //               try {
                //                 AnalyticEvents.noteJoinEvent(
                //                     controller.lectureData.value!.metaData
                //                         .topic.isNotEmpty
                //                         ? controller.lectureData.value!
                //                         .metaData.topic
                //                         : controller.lectureData.value!
                //                         .subjectData.courseName,
                //                     controller.lectureStartTime);
                //               } catch (e) {
                //                 debugPrint(e.toString());
                //               }
                //               SHNavigationManager.navigate(Target(
                //                   identifier: Identifiers.browser,
                //                   value: '',
                //                   title: '',
                //                   redirectUrl: controller
                //                       .onlineRoom.value!.joinURL ??
                //                       ""));
                //             },
                //           ),
                //         ),
                //       ),
                //     ),
                //   );
                // else if (controller.lectureData.value!.shouldShowRegisterButton(currentServerDateTime: controller.lectureDataGot.value!.currentServerDateTime))
                //   return Container(
                //     height: _bottomSheetHeight,
                //     color: HubColor.white,
                //     child: Center(
                //       child: Padding(
                //         padding: const EdgeInsets.all(16.0),
                //         child: SizedBox(
                //           child: controller.lectureData.value!.subscription!.isSubscribed
                //               ? UIKitOutlineButton(
                //               leftIcon:
                //               Icon(Icons.check_circle_outline_rounded),
                //               isEnabled: false,
                //               text: controller.lectureData.value!.subscription!.displayLabel,
                //               onPressed: null,
                //               buttonSize: UIKitButtonSize.medium)
                //               : UIKitFilledButton(
                //               text: controller.lectureData.value!.subscription!.displayLabel,
                //               onPressed: () {
                //                 controller.onTapRegisterEvent(!controller.lectureData.value!.subscription!.isSubscribed);
                //               },
                //               buttonSize: UIKitButtonSize.medium),
                //           width: double.infinity,
                //         ),
                //       ),
                //     ),
                //   );
                // else if (controller.shouldShowMarkAttendance)
                //   return Container(
                //     height: _bottomSheetHeight,
                //     color: HubColor.white,
                //     child: Center(
                //       child: SizedBox(
                //           width: MediaQuery.of(context).size.width,
                //           child: Padding(
                //               padding: const EdgeInsets.all(16.0),
                //               child: GeneralButton(
                //                   buttonTextKey: 'Mark Attendance',
                //                   onPressed: () {
                //                     Get.toNamed(Paths.attendanceBeacon,
                //                         arguments: BeaconAttendanceParams(
                //                             data:
                //                             controller.lectureData.value!));
                //                   }))),
                //     ),
                //   );
                // else
                //   return SizedBox();

                return controller.lectureData.value?.actions == null
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                            children: SSActionFactory.generateButtonList(
                                controller.lectureData.value!.actions!,
                                _getButtonAction)),
                      );
              }));
        });
  }

  Function()? _getButtonAction(SSNavigation action) {
    LectureEventListModel? lecture = controller.lectureData.value;
    switch (action.deeplink) {
      case AlertDeeplinkIdentifiers.hubTakeAttendance:
        return () {
          SchedulePageEvents()
              .eventCtaClick(controller.lectureData.value!, action.deeplink);
          _controller.onTapTakeAttendance.call();
        };
      case AlertDeeplinkIdentifiers.hubMarkLecture:
        return () {
          SchedulePageEvents()
              .eventCtaClick(controller.lectureData.value!, action.deeplink);
          _controller.onTapMarkLecture.call();
        };
      case AlertDeeplinkIdentifiers.hubMarkLectureAndJoin:
        return () {
          SchedulePageEvents()
              .eventCtaClick(controller.lectureData.value!, action.deeplink);
          _controller.onTapMarkLectureAndJoin.call();
        };
      case AlertDeeplinkIdentifiers.hubEditAttendance:
        return () {
          SchedulePageEvents()
              .eventCtaClick(controller.lectureData.value!, action.deeplink);
          _controller.onTapEditAttendance.call();
        };
      default:
        return () {
          SchedulePageEvents()
              .eventCtaClick(controller.lectureData.value!, action.deeplink);
          DeepLinks.getInstance().register(action.deeplink);
        };
    }

    // switch (action.deeplink) {
    //   case AlertDeeplinkIdentifiers.hubTakeAttendance:
    //     return _controller.onTapTakeAttendance;
    //   case AlertDeeplinkIdentifiers.hubMarkLecture:
    //     return _controller.onTapMarkLecture;
    //   case AlertDeeplinkIdentifiers.hubMarkLectureAndJoin:
    //     return _controller.onTapMarkLectureAndJoin;
    //   case AlertDeeplinkIdentifiers.hubEditAttendance:
    //     return _controller.onTapEditAttendance;
    //   default:
    //     return () {
    //       SchedulePageEvents().eventCtaClick(controller.lectureData.value!, action.deeplink);
    //       DeepLinks.getInstance().register(action.deeplink);
    //     };
    // }
  }
}

class NotesPreview extends StatelessWidget {
  final NotesModel notes;
  final void Function()? onClick;

  const NotesPreview({Key? key, required this.notes, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle _titleStyle = GoogleFonts.publicSans(
        fontSize: 16, fontWeight: FontWeight.w700, color: HubColor.grey1);
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
            color: HubColor.primaryTint,
            borderRadius: BorderRadius.circular(4)),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Your Notes", style: _titleStyle),
                      SvgPicture.asset(Assets.svgArrowRight)
                    ],
                  ),
                  Space(height: 12),
                  Text(
                    notes.title,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyText2!.copyWith(
                      color: HubColor.primary,
                    ),
                  )
                ],
              ),
            ),
            if (notes.attachments.isNotEmpty)
              Padding(
                  padding: EdgeInsets.only(left: 20, top: 16),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: notes.attachments
                              .map((e) => _Attachment(attachment: e))
                              .toList())))
          ],
        ),
      ),
    );
  }
}

class _Attachment extends GetView<EventDetailController> {
  final NotesAttachmentModel attachment;

  const _Attachment({Key? key, required this.attachment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _url = attachment.url;
    final String _attachmentName = attachment.name;
    final bool _isPdf = (attachment.url.contains('.pdf'));
    return GestureDetector(
      onTap: () {
        // AnalyticEvents.noteViewAttachmentEvent(
        //     controller.subject,
        //     _attachmentName,
        //     _isPdf ? 'pdf' : 'image',
        //     controller.lectureStartTime);
        if (_isPdf) {
          //todo cht
          // Get.toNamed(Paths.pdfPreview,
          //     arguments: PdfArguments(
          //       url: _url,
          //       name: _attachmentName,
          //       allowShare: false,
          //     ));
        } else {
          // Get.toNamed(Paths.viewImage,
          //     arguments: ViewImageArgument(url: _url, title: _attachmentName));
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: HubColor.white,
            border: Border.all(
              color: HubColor.grey1.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            SvgPicture.asset(Assets.svgAttachment),
            SizedBox(width: 8),
            Container(
                constraints: BoxConstraints(maxWidth: 160),
                child: Text(
                  _attachmentName,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyText2,
                ))
          ],
        ),
      ),
    );
  }
}
