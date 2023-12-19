import 'package:admin_hub_app/theme/colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:hub/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class LectureTimeWidget extends StatelessWidget {
  const LectureTimeWidget({
    Key? key,
    required this.lectureDate,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  final String lectureDate;
  final String? startTime;
  final String? endTime;

  @override
  Widget build(BuildContext context) {

    List<Widget> widgets = [];
    TextStyle style = UIKitDefaultTypography().caption.copyWith(fontWeight: FontWeight.w600);

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
          style: style.copyWith(color: HubColor.lectureTimeDark)));
      if (startTimeSuffix != endTimeSuffix) {
        widgets.add(Text(' $startTimeSuffix',
            style: style.copyWith(color: HubColor.lectureTimeLight)));
      }
      widgets.add(
          Text(' - ', style: style.copyWith(color: HubColor.lectureTimeDark)));
      widgets.add(Text(displayFormat.format(parsedEndTime),
          style: style.copyWith(color: HubColor.lectureTimeDark)));
      widgets.add(Text(' $endTimeSuffix',
          style: style.copyWith(color: HubColor.lectureTimeLight)));

    } else {

      DateFormat inputFormat = DateFormat('yyyy-MM-d');
      DateFormat outputFormat = DateFormat("dd MMM''yy'");
      DateTime startDate = inputFormat.parse(lectureDate);

      widgets.add(Text('Starts on ',
          style: style.copyWith(color: HubColor.lectureTimeLight)));
      widgets.add(Text(outputFormat.format(startDate),
          style: style.copyWith(color: HubColor.lectureTimeDark)));
    }

    return Row(
      children: widgets,
    );
  }
}
