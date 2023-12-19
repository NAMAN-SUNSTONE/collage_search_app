import 'package:admin_hub_app/deep_links/deep_links.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:hub/app_assets/app_json_path.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/data/student/models/lecture_model.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/timetable/widgets/lecture_category_widget.dart';
// import 'package:hub/utils/color_extension.dart';
import 'package:get/get.dart';
// import 'package:hub/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sunstone_ui_kit/widgets/tags/ui_kit_tag.dart';

class ClassDetailLabel extends StatelessWidget {
  const ClassDetailLabel({
    Key? key,
    this.lectureData,
    this.serverDateTime,
    this.deepLink
  }) : super(key: key);

  final LectureEventListModel? lectureData;
  final DateTime? serverDateTime;
  final String? deepLink;

  @override
  Widget build(BuildContext context) {

    TextStyle _subtitleTextStyle() => context.textTheme.subtitle1!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: HubColor.grey1.withOpacity(0.7),
        height: 14.4/10
    );

    Widget _buildStudentAttendanceStatus(){
      bool? isStudentPresent = lectureData?.isStudentPresent;
      if(isStudentPresent == null) return SizedBox.shrink();

      final Color color = isStudentPresent == true ? HubColor.greenLight : HubColor.redLight;
      final IconData icon = isStudentPresent == true ? Icons.check : Icons.close;

      return Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 18 , color: color,),
              SizedBox(width: 4,),
              Text(isStudentPresent ? "Marked Present" : "Marked Absent", style: context.textTheme
                  .subtitle1?.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
              ),)
            ],
          ),

          SizedBox(height: 8,)
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIKitTag(
          title: lectureData!.label ?? lectureData!.category.label,
          tagType: UIKitTagType.custom,
          isSmall: true,
          customForeground: lectureData!.category.bgColor.toColor2(),
          customBackground: lectureData!.category.fgColor.toColor2(),
          icon: SvgPicture.asset(
              _getIconPath(lectureData!.category.identifier)),
          trailingWidget:
          _isClassLive() ? Lottie.asset(Assets.lottieLivePulse) : null,
        ),
        SizedBox(height: 12),
        RichText(text: TextSpan(
          children: [
            TextSpan(
              text: lectureData!.subjectData.courseName.isNotEmpty
                  ? lectureData!.subjectData.courseName
                  : lectureData!.metaData.topic,
              style: context.textTheme.bodyText1?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: HubColor.black1A,
              ),
            ),
            if (deepLink != null) ...[
              WidgetSpan(child: SizedBox(width: 8)),
              WidgetSpan(child: InkWell(
                onTap: () => DeepLinks.getInstance().register(deepLink!),
                  child: Icon(Icons.open_in_new_rounded, color: HubColor.iconColorCircle, size: 20))),
            ]
          ]
        )),
        SizedBox(height: 11),
          _buildStudentAttendanceStatus(),

        if (lectureData!.eventType == 'class')...[
          Row(children: [
            SizedBox(width: 1),
            Text(
              lectureData!.subjectData.specializationId <= 0
                  ? 'Core Subject'
                  : 'Elective Subject ',
              style: _subtitleTextStyle(),
            ),
          ]),
          SizedBox(height: 8),
        ],

        Row(children: [
          SizedBox(width: 1),
          Text(
            _getEventDate(),
            style: _subtitleTextStyle()
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SvgPicture.asset(
              Assets.svgCircle,
              fit: BoxFit.contain,
              width: 4,
              height: 4,
              color: HubColor.hintText,
            ),
          ),
          Text(
            _getEventTime(),
            style: _subtitleTextStyle()
          ),
        ]),

        SizedBox(height: 8,),

        if (lectureData!.recurringDays != null)
          Text(lectureData!.recurringDays!, style: _subtitleTextStyle()),
      ],
    );
  }

  //Method To Get The LEcture/Event Date
  String _getEventDate() {
    final _dateFormatLectureDate = DateFormat('yyyy-MM-d');
    String eventDate = '';

    DateTime lectureDate = lectureData!.lectureDate.isNotEmpty
        ? _dateFormatLectureDate.parse(lectureData!.lectureDate)
        : DateTime.now();

    final serverDateTimeNew = _dateFormatLectureDate.parse(
        _dateFormatLectureDate.format((serverDateTime ?? DateTime.now())));

    if (lectureDate.difference(serverDateTimeNew).inDays == 0) {
      eventDate = 'Today';
    } else if (lectureDate.difference(serverDateTimeNew).inDays == 1) {
      eventDate = 'Tomorrow';
    } else {
      eventDate = DateFormat('EEEE, d MMM ’yy').format(lectureDate);
    }

    return eventDate;
  }

  //Method To Get The LEcture/Event Time
  String _getEventTime() {
    String eventTime = '';

    if (lectureData?.lectureStartTime != null && lectureData?.lectureEndTime != null) {
      final _timeFormat = DateFormat('HH:mm:ss');
      final df2 = DateFormat('hh:mm a');

      DateTime lectureStartTime =
      _timeFormat.parse(lectureData!.lectureStartTime!);
      DateTime lectureEndTime = _timeFormat.parse(lectureData!.lectureEndTime!);

      eventTime =
      '${df2.format(lectureStartTime)} - ${df2.format(lectureEndTime)}';

    }
    return eventTime;
  }

  bool _isClassLive() {

    if (lectureData?.lectureStartTime != null && lectureData?.lectureEndTime != null) {
      bool isClassLive = false;
      final _dayFormat = DateFormat('yyyy-MM-d');
      final _timeFormat = DateFormat('HH:mm:ss');

      DateTime currentDateTime = serverDateTime != null
          ? serverDateTime!
          : DateTime.now();

      DateTime lectureDate = _dayFormat.parse(lectureData!.lectureDate);
      DateTime lectureStartTime = _timeFormat.parse(lectureData!.lectureStartTime!);
      DateTime lectureEndTime = _timeFormat.parse(lectureData!.lectureEndTime!);

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
