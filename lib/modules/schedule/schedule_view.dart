import 'package:admin_hub_app/base/central_state.dart';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/modules/schedule/schedule_controller.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/widgets/buttons.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:admin_hub_app/widgets/ss_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      global: false,
      init: ScheduleController(),
      builder: (controller) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  "Today's Schedule",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 36, right: 16),
                  child: InkWell(
                    onTap: centralState.onLogOut,
                    child: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                const SpaceLarge()
              ],
            ),
          ),
          backgroundColor: HubColor.white,
          body: RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: Obx(
              () => SSLoader.light(
                status: controller.status.value,
                onRetry: controller.onRefresh,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                DateIndicator(
                                    date: DateTime.now(), isSelected: true),
                                Flexible(
                                  child: Container(
                                    width: 1,
                                    color: HubColor.lightBlack,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Space(),
                                Text(
                                  "${controller.eventList.length} Events",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: HubColor.outlineButtonText),
                                ),
                                if (controller.eventList.isEmpty)
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 32),
                                        child: Text("No classes available today"),
                                      ),
                                    ],
                                  ),
                                Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding:
                                          const EdgeInsets.only(right: 16, top: 4),
                                      itemCount: controller.eventList.length,
                                      itemBuilder: (c, i) => EventCard(
                                          event: controller.eventList[i])),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

class EventCard extends GetView<ScheduleController> {
  final EventModel event;
  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = HubColor.purple2;
    final Color iconColor = HubColor.iconColorCircle;
    final String campus = event.campusName ?? '';
    final String course = event.programName ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => controller.onEventClick(event),
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ClassTag(event),
                  LectureTimeWidget(
                    lectureDate: event.lectureDate!,
                    startTime: event.lectureStartTime,
                    endTime: event.lectureEndTime,
                  ),
                ],
              ),
              Space(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.subjectName ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontSize: 14),
                        ),
                        const Space(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  course,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          fontSize: 10,
                                          color: iconColor.withOpacity(0.5)),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: color),
                                ),
                                Text(
                                  campus,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                          fontSize: 10,
                                          color: iconColor.withOpacity(0.5)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (event.isAttendanceTaken)
                Container(
                    margin: EdgeInsets.only(top: 8),
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: HubColor.white),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Total Present',
                                style: context.textTheme.caption
                                    ?.copyWith(color: HubColor.grey1)),
                            TextSpan(
                                text: '  ${event.studentPresent ?? ""}',
                                style: context.textTheme.caption?.copyWith(
                                  color: HubColor.green2,
                                  fontWeight: FontWeight.w600,
                                )),
                            TextSpan(
                                text: ' / ${event.studentCount}',
                                style: context.textTheme.caption?.copyWith(
                                    color: HubColor.primary,
                                    fontWeight: FontWeight.w600)),
                          ])),
                          GestureDetector(
                            onTap: () => controller.onEditAttendance(event),
                            child: Container(
                              alignment: Alignment.center,
                              height: 26,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: HubColor.dividerColor,
                                  )),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Text("EDIT ",
                                        style: context.textTheme.caption
                                            ?.copyWith(
                                                color: HubColor.primary,
                                                fontWeight: FontWeight.w600)),
                                    Icon(
                                      CupertinoIcons.arrow_right,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              else
                Container(
                  padding: EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: CustomButton(
                    height: 36,
                    onPressed: () => /*controller.onTakeAttendance(event)*/ null,
                    child: Text("Take Attendance",
                        style: context.textTheme.button),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class DateIndicator extends StatelessWidget {
  DateIndicator({required this.date, required this.isSelected});

  final DateTime date;
  final bool isSelected;

  final DateFormat _dateFormat = DateFormat("dd");
  final DateFormat _monthFormat = DateFormat("MMM");

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? HubColor.primary : HubColor.white),
              child: Center(
                child: Text(_dateFormat.format(date),
                    style: UIKitDefaultTypography().headline1.copyWith(
                        fontSize: 12,
                        color: isSelected
                            ? HubColor.white
                            : HubColor.primaryText)),
              ),
            ),
            Text(_monthFormat.format(date),
                style: UIKitDefaultTypography().bodyText2.copyWith(
                    color: isSelected
                        ? HubColor.primary
                        : HubColor.lectureTimeLight)),
          ],
        ),
      ),
    );
  }
}

class LectureTimeWidget extends StatelessWidget {
  const LectureTimeWidget({
    Key? key,
    required this.lectureDate,
    required this.startTime,
    required this.endTime,
    this.textStyle,
  }) : super(key: key);

  final String lectureDate;
  final String? startTime;
  final String? endTime;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    TextStyle style = textStyle ??
        UIKitDefaultTypography().caption.copyWith(fontWeight: FontWeight.w600);

    if (startTime != null && endTime != null) {
      DateFormat parsingFormat = DateFormat('HH:mm:ss');
      DateFormat displayFormat = DateFormat('hh:mm');
      String am = 'AM';
      String pm = 'PM';

      DateTime parsedStartTime = parsingFormat.parse(startTime!);
      DateTime parsedEndTime = parsingFormat.parse(endTime!);

      String startTimeSuffix = parsedStartTime.hour >= 12 ? pm : am;
      String endTimeSuffix = parsedEndTime.hour >= 12 ? pm : am;

      widgets.add(Text(displayFormat.format(parsedStartTime),
          style: textStyle ?? style.copyWith(color: HubColor.lectureTimeDark)));
      if (startTimeSuffix != endTimeSuffix) {
        widgets.add(Text(' $startTimeSuffix',
            style:
                textStyle ?? style.copyWith(color: HubColor.lectureTimeLight)));
      }
      widgets.add(Text(' - ',
          style: textStyle ?? style.copyWith(color: HubColor.lectureTimeDark)));
      widgets.add(Text(displayFormat.format(parsedEndTime),
          style: textStyle ?? style.copyWith(color: HubColor.lectureTimeDark)));
      widgets.add(Text(' $endTimeSuffix',
          style:
              textStyle ?? style.copyWith(color: HubColor.lectureTimeLight)));
    } else {
      DateFormat inputFormat = DateFormat('yyyy-MM-d');
      DateFormat outputFormat = DateFormat("dd MMM''yy'");
      DateTime startDate = inputFormat.parse(lectureDate);

      widgets.add(Text('Starts on ',
          style:
              textStyle ?? style.copyWith(color: HubColor.lectureTimeLight)));
      widgets.add(Text(outputFormat.format(startDate),
          style: textStyle ?? style.copyWith(color: HubColor.lectureTimeDark)));
    }

    return Row(
      children: widgets,
    );
  }
}
