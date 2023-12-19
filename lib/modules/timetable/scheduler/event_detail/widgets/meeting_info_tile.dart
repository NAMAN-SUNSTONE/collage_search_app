import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/data/student/student.dart';
// import 'package:hub/theme/colors.dart';

class MeetingDetailsExpandableTile extends StatelessWidget {
  final RoomModel room;

  const MeetingDetailsExpandableTile({Key? key, required this.room})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? _textStyle = context.theme.textTheme.bodyText1?.copyWith(
        fontSize: 14, fontWeight: FontWeight.w400, color: HubColor.grey1);

    TextStyle? _expandedTextStyle =
        _textStyle?.copyWith(color: HubColor.grey1.withOpacity(0.7));

    return ExpansionTile(
      title: Text(
        "Zoom Meeting",
        style: _textStyle,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.topLeft,
      leading: SvgPicture.asset(
        Assets.svgZoomLogo,
        height: 30,
        width: 30,
      ),
      childrenPadding: EdgeInsets.only(left: 40),
      children: [
        Text(
          'Meeting ID : ${room.meetingID}',
          style: _expandedTextStyle,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Passcode : ${room.passcode}',
          style: _expandedTextStyle,
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: room.joinURL!)).then(
                (value) => Fluttertoast.showToast(msg: 'Meeting url copied'));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 8, top: 8, bottom: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: HubColor.primary,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Copy',
                  style: _textStyle?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: HubColor.primary,
                      fontSize: 12),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}