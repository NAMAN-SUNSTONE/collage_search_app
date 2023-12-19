import 'package:admin_hub_app/base/central_state.dart';
import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/modules/calendar/ui/widgets/calendar_error_state.dart';
import 'package:admin_hub_app/modules/calendar/ui/widgets/date_indicator.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/timetable/data/image_row_card.dart';
import 'package:admin_hub_app/utils/datetime_extension.dart';
import 'package:admin_hub_app/utils/no_overscroll_behavior.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:admin_hub_app/widgets/buttons.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:admin_hub_app/widgets/row_image.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:admin_hub_app/widgets/ss_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/calendar/ui/widgets/calendar_error_state.dart';
// import 'package:hub/calendar/ui/widgets/date_indicator.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/data/home/model/image_row_card.dart';
// import 'package:hub/data/student/models/lecture_model.dart';
// import 'package:hub/sunstone_base/ui/widgets/no_overscroll_behavior.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/theme/typography.dart';
// import 'package:hub/ui/home/lead_cards/row_image.dart';
// import 'package:hub/utils/extensions.dart';
// import 'package:hub/utils/layout.dart';
// import 'package:hub/widgets/buttons.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:table_calendar/table_calendar.dart';
import 'package:visibility_detector/visibility_detector.dart';

import './widgets/calendar_widget.dart';
import './widgets/single_lecture_widget.dart';
// import '../../constants/screen_names.dart';
import '../../theme/colors.dart';
import 'timetable_controller.dart';

class TimetableView extends GetView<TimetableController> {
  const TimetableView({Key? key}) : super(key: key);

  final double monthHeaderAspectRatio = 107 / 21;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TimetableController(),
      builder: (
        (controller) {
          return Obx(() => SSLoader.light(
                  status: controller.status.value,
                  child: VisibilityDetector(
                    key: controller.calendarVisibilityKey,
                    onVisibilityChanged: controller.onCalendarVisibilityChange,
                    child: Scaffold(
                      appBar: SHAppBar(
                        title: controller.calendarTitle,
                        // onTapTitle: controller.onCalendarSwitch,//todo cht
                        titleSize: TitleSize.large,
                        actions: [
                          // UIKitTextButton(text: 'Sync+', onPressed: controller.onSyncClick),
                          Container(
                              width: 50,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              margin: EdgeInsets.only(right: 16),
                              child: GeneralButton(
                                onPressed: controller.onTodayPressed,
                                elevation: 0,
                                btnbackColor: HubColor.primary.withOpacity(
                                    controller.isTodayButtonActive.value ? 1 : 0.5),
                                buttonTextKey: "Today",
                                btnTextFontWeight: FontWeight.w600,
                                textStyle: UIKitDefaultTypography()
                                    .button
                                    .copyWith(color: HubColor.white),
                                paddingBtnStyle:
                                    MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(0)),
                              ))
                        ],
                      ),
                      body: Column(
                        children: [
                          // AnimatedSwitcher(
                          //     duration: Duration(milliseconds: 300),
                          //     transitionBuilder: (child, animation) {
                          //       return SizeTransition(
                          //           sizeFactor: animation, child: child);
                          //     },
                          //     child: controller.isCalendarOpen.value
                          //         ? CalendarCard(
                          //             // publisher: controller.publisher,
                          //             selectedDate: controller.selectedDate.value,
                          //             calendarFormat: CalendarFormat.month,
                          //             onDaySelected: controller.onDateSelected,
                          //             eventCallback: controller.eventCallback,
                          //             focusedDate: controller.focusedDate,
                          //             onPageChanged: controller.onPageChanged,
                          //             years: controller.admissionYears,
                          //             onCalendarCreated:
                          //                 controller.onCardCalendarCreated)
                          //         : null),
                          if (controller.marketingBannerRowCardData.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.fromLTRB(16,
                                  controller.isCalendarOpen.value ? 16 : 0, 16, 16),
                              child: _marketingRow(
                                  context, controller.marketingBannerRowCardData),
                            )
                          ],
                          if (controller.calendar.value.serverTime != null) ...[
                            if (controller.calendar.value.timeline.isNotEmpty) ...[
                              Expanded(
                                child: Stack(
                                  children: [
                                    NotificationListener<ScrollEndNotification>(
                                      child: ScrollConfiguration(
                                        behavior: NoOverscrollBehavior(),
                                        child: ScrollablePositionedList.builder(
                                          itemPositionsListener:
                                              controller.positionListener,
                                          itemScrollController:
                                              controller.positionedScrollController,
                                          itemCount: controller
                                              .calendar.value.timeline.length,
                                          itemBuilder: (context, index) =>
                                              _generateTimelineItem(
                                                  controller
                                                      .calendar.value.timeline.keys
                                                      .toList()[index],
                                                  controller.calendar.value.timeline[
                                                      controller.calendar.value
                                                          .timeline.keys
                                                          .toList()[index]]!),
                                        ),
                                      ),
                                      onNotification: controller.onScrollNotification,
                                    ),
                                    //if (controller.calendar.value.nonEmptyCalendarCount > 0)
                                    //   ColoredBox(
                                    //     color: HubColor.red1,
                                    //     child: Padding(
                                    //       padding:
                                    //           const EdgeInsets.symmetric(horizontal: 11),
                                    //       child: DateIndicator(
                                    //           date: controller.currentTopDate.value,
                                    //           isSelected: true),
                                    //     ),
                                    //   ),
                                  ],
                                ),
                              )
                            ] else ...[
                              SizedBox()
                            ],
                          ] else if (controller.status.value == Status.error) ...[
                            CalendarErrorState(onRetry: controller.onRetry)
                          ]
                        ],
                      ),
                    ),
                  ),
                ));
        }
      ),
    );
  }

  Widget _generateTimelineItem(
      String key, List<LectureEventListModel> lectures) {
    DateTime currentLectureDate =
        key.toDateTime(dateFormat: controller.dayFormat.pattern!);

    if (lectures.isNotEmpty) {
      // list of events for each date
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return IntrinsicHeight(
              child: Column(
                children: [
                  if (currentLectureDate.day == 1)
                    _generateMonthHeader(currentLectureDate),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 11),
                              child: DateIndicator(
                                  date: currentLectureDate, isSelected: false),
                            ),
                            SizedBox(width: 23.5),
                            Expanded(
                                child: Container(
                                    color: HubColor.calendarUnselectedColor,
                                    width: 1,
                                    height: double.infinity)),
                            SizedBox(width: 23.5)
                          ],
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 6, left: 4, bottom: 4),
                              child: Text(
                                  '${lectures.length} ${lectures.length == 1 ? 'Event' : 'Events'}',
                                  style: UIKitDefaultTypography()
                                      .subtitle2
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: HubColor.primary)),
                            ),
                            LectureCardSingle(
                                padding: EdgeInsets.fromLTRB(2, 0, 16, 12),
                                currentServerDateTime:
                                    controller.currentServerDataTime.value,
                                // publisher: controller.publisher,//todo cht
                                data: lectures[index],
                                // screenName: ScreenName.timeTable,//todo cht
                                widthFactor: 1,
                                onTapTakeAttendance: controller.onTapTakeAttendance,
                                onTapMarkLecture: controller.onTapMarkLecture,
                                onTapMarkLectureAndJoin: controller.onTapMarkLectureAndJoin,
                                onTapEditAttendance: controller.onTapEditAttendance),
                          ],
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(width: 24),
                  Container(
                      color: HubColor.calendarUnselectedColor,
                      width: 1,
                      height: double.infinity),
                  SizedBox(width: 24),
                  Expanded(
                    child: LectureCardSingle(
                        padding: EdgeInsets.fromLTRB(2, 0, 16, 12),
                        currentServerDateTime:
                            controller.currentServerDataTime.value,
                        // publisher: controller.publisher,
                        data: lectures[index],
                        // screenName: ScreenName.timeTable,
                        widthFactor: 1,
                        onTapTakeAttendance: controller.onTapTakeAttendance,
                        onTapMarkLecture: controller.onTapMarkLecture,
                        onTapMarkLectureAndJoin: controller.onTapMarkLectureAndJoin,
                        onTapEditAttendance: controller.onTapEditAttendance),
                  ),
                ],
              ),
            );
          }
        },
        itemCount: lectures.length,
      );
    } else {
      return IntrinsicHeight(
        child: Column(
          children: [
            if (currentLectureDate.day == 1)
              _generateMonthHeader(currentLectureDate),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        child: DateIndicator(
                            date: currentLectureDate, isSelected: false),
                      ),
                      SizedBox(width: 23.5),
                      Expanded(
                          child: Container(
                              color: HubColor.calendarUnselectedColor,
                              width: 1,
                              height: 8)),
                      SizedBox(width: 23.5)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 8),
                    child: Text('No events',
                        style: UIKitDefaultTypography().subtitle2.copyWith(
                            fontWeight: FontWeight.w600,
                            color: HubColor.calendarEmptyStateTitle)),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _generateMonthHeader(DateTime month) {
    final String monthHeaderFormat = month.isSameYear(DateTime.now())
        ? DateFormat.MMMM().pattern!
        : DateFormat.yMMMM().pattern!;

    return IntrinsicHeight(
      child: Stack(
        children: [
          AspectRatio(
              aspectRatio: monthHeaderAspectRatio,
              // child: SvgPicture.asset(AppSvgPath.getMonthHeader(month),
              //     width: double.infinity)),//todo cht
        child: SizedBox()),//todo cht
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HubColor.white,
                    HubColor.white.withOpacity(.3),
                    HubColor.transparent
                  ],
                  // begin: const FractionalOffset(0.0, 0.5),
                  // end: const FractionalOffset(0.0, 0.5),
                  stops: [0.0, 0.3, 1.0],
                ),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(DateFormat(monthHeaderFormat).format(month),
                      style: UIKitDefaultTypography()
                          .headline1
                          .copyWith(fontSize: 20, color: HubColor.black))))
        ],
      ),
    );
  }

  Widget _marketingRow(BuildContext context, List<ImageRowCard> cards) {
    double padding = 16;
    double margin = 12;
    double screenWidth = MediaQuery.of(context).size.width;
    double widgetWidth = 0;

    // non empty check to avoid DivisionByZeroException
    if (cards.isNotEmpty) {
      // to fit multiple cards in a row
      widgetWidth = screenWidth / cards.length;

      // if multiple cards are there, subtract the padding among cards and subtract the margin in between
      if (cards.length > 1) {
        widgetWidth -= padding;
        widgetWidth -= (margin / cards.length);

        // if card is single just subtract the padding fully
      } else {
        widgetWidth -= padding * 2;
      }
    }

    // no cards, no visible widget
    if (cards.isEmpty)
      return SizedBox();

    // if single card, return single widget
    else if (cards.length == 1)
      return SizedBox(
          width: widgetWidth,
          child: RowImage(story: cards.first, length: cards.length));

    // if multiple cards, add in row then return
    else
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: widgetWidth,
              child: RowImage(story: cards.first, length: cards.length)),
          SizedBox(
              width: widgetWidth,
              child: RowImage(story: cards.last, length: cards.length)),
        ],
      );
  }
}
