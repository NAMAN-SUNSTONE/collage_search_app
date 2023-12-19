import 'package:admin_hub_app/modules/timetable/data/event_month_model.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:hub/analytics/events_publisher.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/data/student/student.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({
    Key? key,
    this.onDaySelected,
    this.eventCallback,
    this.onPageChanged,
    this.onYearSelected,
    required this.years,
    // required this.publisher,
    required this.focusedDate,
    required this.selectedDate,
    this.calendarFormat = CalendarFormat.week,
    this.onCalendarCreated
  }) : super(key: key);

  final List<int> years;
  // final EventsPublisher publisher; //todo cht

  final DateTime focusedDate;
  final DateTime selectedDate;
  final OnDaySelected? onDaySelected;
  final CalendarFormat calendarFormat;
  final ValueChanged<int?>? onYearSelected;
  final List<EventDateModel> Function(DateTime day)? eventCallback;
  final void Function(DateTime focusedDay)? onPageChanged;
  final void Function(PageController pageController)? onCalendarCreated;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HubColor.calendarGradient.withOpacity(0),
                HubColor.calendarGradient.withOpacity(0),
                HubColor.calendarGradient.withOpacity(0),
                HubColor.calendarGradient.withOpacity(.1),
                HubColor.calendarGradient.withOpacity(.2)
              ]),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: TableCalendar<EventDateModel>(
          onCalendarCreated: onCalendarCreated,
          calendarFormat: CalendarFormat.month,
          firstDay: DateTime.utc(years.first, 1, 1),
          lastDay: DateTime.utc(years.last, 12, 31),
          focusedDay: focusedDate,
          selectedDayPredicate: (date) =>
              date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year,
          onDaySelected: onDaySelected,
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: _buildWeekDayText,
            weekendStyle: UIKitDefaultTypography()
                .bodyText1
                .copyWith(color: HubColor.calendarUnselectedColor),
            weekdayStyle: UIKitDefaultTypography()
                .bodyText1
                .copyWith(color: HubColor.calendarUnselectedColor),
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          calendarStyle: CalendarStyle(
            cellMargin: EdgeInsets.all(2),
            todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HubColor.transparent,
                border: Border.all(color: HubColor.primary, width: 1.05)),
            selectedDecoration:
                BoxDecoration(shape: BoxShape.circle, color: HubColor.primary),
            defaultTextStyle: UIKitDefaultTypography()
                .bodyText2
                .copyWith(color: HubColor.grey1),
            weekendTextStyle: UIKitDefaultTypography()
                .bodyText2
                .copyWith(color: HubColor.grey1),
            outsideTextStyle: UIKitDefaultTypography()
                .bodyText2
                .copyWith(color: HubColor.calendarUnselectedColor),
            disabledTextStyle: UIKitDefaultTypography()
                .bodyText2
                .copyWith(color: HubColor.calendarUnselectedColor),
            selectedTextStyle: UIKitDefaultTypography()
                .bodyText2
                .copyWith(color: HubColor.white),
            todayTextStyle: UIKitDefaultTypography()
                .bodyText2
                .copyWith(color: HubColor.grey1),
          ),
          headerVisible: false,
          rowHeight: 48,
          daysOfWeekHeight: 48,
          calendarBuilders: CalendarBuilders(
            singleMarkerBuilder: _classMarkerBuilder,
          ),
          eventLoader: eventCallback,
          onPageChanged: onPageChanged,
        ),
      ),
    );
  }

  String _buildWeekDayText(DateTime date, dynamic locale) =>
      DateFormat(DateFormat.ABBR_WEEKDAY, locale).format(date).substring(0, 2);

  Widget? _classMarkerBuilder(
          BuildContext context, DateTime day, EventDateModel event) =>
      _lecturePointerWidget(isSelected: day.isSameDate(selectedDate));
}

Widget _lecturePointerWidget({required bool isSelected}) {
  return isSelected
      ? SizedBox()
      : Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 4,
          width: 4,
          child: SvgPicture.asset(
            /*AppSvgPath.circle*/''//todo cht
            ,color: HubColor.primary,
          ),
        );
}
