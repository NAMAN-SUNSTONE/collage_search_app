import 'dart:developer';

import 'package:admin_hub_app/analytics/events/screens/schedule.dart';
import 'package:admin_hub_app/constants/constants.dart';
import 'package:admin_hub_app/deep_links/deep_links.dart';
import 'package:admin_hub_app/deep_links/page_navigator.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/content_view/ss_navigation.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/modules/timetable/widgets/lecture_time_widget.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/ss_action_factory.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:hub/analytics/event_constants.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/analytics/events_publisher.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/beacon/beacon_attendance_controller.dart';
// import 'package:hub/constants/app_constants.dart';
// import 'package:hub/constants/constants.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/data/student/models/lecture_model.dart';
// import 'package:hub/data/student/models/target_model.dart';
// import 'package:hub/remote_config/remote_config_service.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/sunstone_base/data/ss_navigation.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_action_factory.dart';
// import 'package:hub/theme/colors.dart';

// import 'package:hub/ui/timetable/widgets/lecture_time_widget.dart';
// import 'package:hub/utils/extensions.dart';
// import 'package:hub/utils/layout.dart';
//
// import 'package:hub/utils/navigator/navigator.dart';

import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';
// import 'package:hub/app_assets/app_json_path.dart';

class LectureDataToPass {
  late final int eventId;
  late final String? currentServerDateTime;
  late final String? type;

  LectureDataToPass(
      {required this.eventId, this.currentServerDateTime, this.type});

  LectureDataToPass.fromJson(Map<String, String?> json) {
    eventId = int.parse(json['eventId']!);
    currentServerDateTime = json['currentServerDateTime'];
    type = json['type'];
  }
  //generates a mapped data that can be sent to another page in flutter web
  Map<String, String> toJson() {
    Map<String, String> map = {};
    map['eventId'] = eventId.toString();
    if (currentServerDateTime != null)
      map['currentServerDateTime'] = currentServerDateTime!;
    if (type != null) map['type'] = type!;
    return map;
  }
}

class LectureCardSingle extends StatelessWidget {
  LectureCardSingle({
    Key? key,
    required this.data,
    // required this.screenName,//todo cht
    this.currentServerDateTime,
    // required this.publisher,//todo cht
    this.widthFactor = 0.8,
    this.contentPadding = const EdgeInsets.fromLTRB(12, 0, 12, 10),
    this.padding = EdgeInsets.zero,
    this.showFlexibleItems = true,
    this.onTapRegister,
    this.onTapTakeAttendance,
    this.onTapMarkLecture,
    this.onTapMarkLectureAndJoin,
    this.onTapEditAttendance,
    this.cardSequence,
  }) : super(key: key);

  final LectureEventListModel data;
  final String? currentServerDateTime;
  final double widthFactor;
  // final String screenName;//todo cht
  final EdgeInsets contentPadding;
  // final EventsPublisher publisher;//todo cht
  final EdgeInsets padding;
  final bool showFlexibleItems;
  final void Function(LectureEventListModel eventData, bool toRegister)?
      onTapRegister;
  final void Function(LectureEventListModel eventData)? onTapTakeAttendance;
  final void Function(LectureEventListModel eventData)? onTapMarkLecture;
  final void Function(LectureEventListModel eventData)? onTapMarkLectureAndJoin;
  final void Function(LectureEventListModel eventData)? onTapEditAttendance;
  final int? cardSequence;

  final String examType = 'exam';

  // bool get _showAttendanceButton =>
  //     (Get.find<RemoteConfigService>().beaconAttendanceEnabled &&
  //         data.onlineRoom == null &&
  //         data.classType != '1' &&
  //         data.eventType != examType &&
  //         _isClassToday());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToDetailPage,
      child: Container(
        width: double.infinity,
        padding: padding,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: data.category.cardColor.toColor2(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showFlexibleItems && !(data.bannerURL.isNullOrBlank)) ...[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: AspectRatio(
                      aspectRatio: UIConstants.eventBannerAspectRatio,
                      child: CachedNetworkImage(
                          imageUrl: data.bannerURL!, fit: BoxFit.cover)),
                ),
                SizedBox(height: 8),
              ] else ...[
                SizedBox(height: 10),
              ],
              Padding(
                padding: contentPadding,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            UIKitTag(
                              title: data.label ?? data.category.label,
                              tagType: UIKitTagType.custom,
                              isSmall: true,
                              customForeground:
                                  data.category.fgColor.toColor2(),
                              customBackground:
                                  data.category.bgColor.toColor2(),
                              icon: SvgPicture.asset(
                                  _getIconPath(data.category.identifier)),
                              trailingWidget: _isClassLive()
                                  ? Lottie.asset(Assets.lottieLivePulse)
                                  : null,
                            )
                          ],
                        ),
                        LectureTimeWidget(
                          lectureDate: data.lectureDate,
                          startTime: data.lectureStartTime,
                          endTime: data.lectureEndTime,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.subjectData.courseName.isNotEmpty
                                ? data.subjectData.courseName
                                : data.metaData.topic,
                            maxLines: showFlexibleItems ? null : 1,
                            style: UIKitDefaultTypography().button.copyWith(
                                color: HubColor.primaryText,
                                overflow: showFlexibleItems ? null : TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (data.eventType == 'class') ...[
                                Text(
                                  data.subjectData.specializationId <= 0
                                      ? 'Core'
                                      : 'Elective',
                                  style: UIKitDefaultTypography()
                                      .caption
                                      .copyWith(
                                          color: data.category.accentColor
                                              .toColor2()),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: SvgPicture.asset(
                                    Assets.svgCircle,
                                    fit: BoxFit.contain,
                                    width: 4,
                                    height: 4,
                                    color: data.category.accentColor.toColor2(),
                                  ),
                                ),
                              ],
                              Text(
                                _getClassType(),
                                style: UIKitDefaultTypography()
                                    .caption
                                    .copyWith(
                                        color: data.category.accentColor
                                            .toColor2()),
                              ),
                              if (data.classType == '2') ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: SvgPicture.asset(
                                    Assets.svgCircle,
                                    fit: BoxFit.contain,
                                    width: 4,
                                    height: 4,
                                    color: data.category.accentColor.toColor2(),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data.campusRoomData.roomNo,
                                    style: UIKitDefaultTypography()
                                        .caption
                                        .copyWith(
                                            color: data.category.accentColor
                                                .toColor2()),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                              if (data.attachments.isNotEmpty) ...[
                                Spacer(),
                                Icon(Icons.attachment_rounded,
                                    color: data.category.accentColor.toColor2(),
                                    size: 14)
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (data.actions != null) ...[
                      SizedBox(height: 12),
                      Row(
                      children: SSActionFactory.generateButtonList(data.actions!, _getButtonAction
                    ))
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    )/*.hoverable()*/;
  }

  Function()? _getButtonAction(SSNavigation action) {

    switch (action.deeplink) {
      case AlertDeeplinkIdentifiers.hubTakeAttendance:
        return () {
          SchedulePageEvents().eventCtaClick(data, action.deeplink);
          onTapTakeAttendance?.call(data);
        };
      case AlertDeeplinkIdentifiers.hubMarkLecture:
        return () {
          SchedulePageEvents().eventCtaClick(data, action.deeplink);
          onTapMarkLecture?.call(data);
        };
      case AlertDeeplinkIdentifiers.hubMarkLectureAndJoin:
        return () {
          SchedulePageEvents().eventCtaClick(data, action.deeplink);
          onTapMarkLectureAndJoin?.call(data);
        };
      case AlertDeeplinkIdentifiers.hubEditAttendance:
        return () {
          SchedulePageEvents().eventCtaClick(data, action.deeplink);
          onTapEditAttendance?.call(data);
        };
      default:
        return () {
          SchedulePageEvents().eventCtaClick(data, action.deeplink);
          DeepLinks.getInstance().register(action.deeplink);
        };
    }
  }

  void _goToDetailPage() {
    //todo cht
    //Analytics Event
    // AnalyticEvents.calenderEventClick(
    //   data.metaData.topic.isNotEmpty
    //       ? data.metaData.topic
    //       : data.subjectData.courseName,
    //   data.lectureStartTime ?? '',
    //   cardSequence?.toString() ?? '',
    // );
    Get.toNamed(
      Paths.lectureDetailView,
      parameters: LectureDataToPass(
              eventId: data.id,
              currentServerDateTime: currentServerDateTime,
              type: data.type)
          .toJson(),
    );
  }

  String _getClassType() {
    String classType = 'Online';
    switch (data.classType) {
      case "1":
        classType = 'Online';
        break;
      case "2":
        classType = 'Offline';
        break;
      case "3":
        classType = 'Studio';
        break;
    }
    return classType;
  }

  bool _isClassToday() {
    if (data.lectureStartTime != null && data.lectureEndTime != null) {
      final _dayFormat = DateFormat('yyyy-MM-d');
      final _timeFormat = DateFormat('HH:mm:ss');
      final _currentTimeFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');

      DateTime currentDateTime = currentServerDateTime != null
          ? _currentTimeFormat.parse((currentServerDateTime!), true).toLocal()
          : DateTime.now();
      DateTime todayDate = DateTime(currentDateTime.year, currentDateTime.month,
          currentDateTime.day, 0, 0, 0, 0, 0);

      DateTime lectureDate = _dayFormat.parse(data.lectureDate);
      DateTime lectureStartTime = _timeFormat.parse(data.lectureStartTime!);

      DateTime lectureStartDateTime = DateTime(
          lectureDate.year,
          lectureDate.month,
          lectureDate.day,
          lectureStartTime.hour,
          lectureStartTime.minute,
          lectureStartTime.second);
      return (lectureStartDateTime.isAfter(todayDate) &&
          lectureStartDateTime.isBefore(todayDate.add(Duration(days: 1))));
    }
    return false;
  }

  bool _isClassLive() {
    if (data.lectureStartTime != null && data.lectureEndTime != null) {
      bool isClassLive = false;
      final _dayFormat = DateFormat('yyyy-MM-d');
      final _timeFormat = DateFormat('HH:mm:ss');
      final _currentTimeFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');

      DateTime currentDateTime = currentServerDateTime != null
          ? _currentTimeFormat.parse((currentServerDateTime!), true).toLocal()
          : DateTime.now();

      DateTime lectureDate = _dayFormat.parse(data.lectureDate);
      DateTime lectureStartTime = _timeFormat.parse(data.lectureStartTime!);
      DateTime lectureEndTime = _timeFormat.parse(data.lectureEndTime!);

      DateTime lectureStartDateTime = DateTime(
          lectureDate.year,
          lectureDate.month,
          lectureDate.day,
          lectureStartTime.hour,
          lectureStartTime.minute,
          lectureStartTime.second);
      DateTime lectureEndDateTime = DateTime(
          lectureDate.year,
          lectureDate.month,
          lectureDate.day,
          lectureEndTime.hour,
          lectureEndTime.minute,
          lectureEndTime.second);

      if (currentDateTime.isAfter(lectureStartDateTime) &&
          currentDateTime.isBefore(lectureEndDateTime)) {
        isClassLive = true;
      }
      return isClassLive;
    }
    return false;
  }

  String _getIconPath(String lectureCategory) {
    String iconPath = Assets.svgCircle;
    switch (lectureCategory.toLowerCase()) {
      case 'class':
      case 'exam':
        iconPath = Assets.svgIcClass;
        break;
      case 'bootcamp':
      case 'placement':
        iconPath = Assets.svgIcBootcamp;
        break;
      case 'extra_curricular':
      case 'event':
        iconPath = Assets.svgIcCalendarFilled;
    }

    return iconPath;
  }
}
