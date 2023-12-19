import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/content_view/lecture_category_model.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class Space extends StatelessWidget {
  final double? height;
  final double factor;

  const Space({Key? key, this.height, this.factor = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (8 * factor),
    );
  }
}

class SpaceLarge extends StatelessWidget {
  final double? height;
  final double factor;

  const SpaceLarge({Key? key, this.height, this.factor = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (16 * factor),
    );
  }
}

class SpaceHorizontal extends StatelessWidget {
  final double? width;
  final double factor;

  const SpaceHorizontal({super.key, this.width, this.factor = 1});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? (16 * factor),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final double left;
  final double top;
  final double right;
  final double bottom;
  final Color? color;
  final double width;
  final double? height;

  CustomDivider(
      {this.left = 0,
        this.top = 0,
        this.right = 0,
        this.bottom = 0,
        this.color,
        this.height,
        this.width = 1.0});

  @override
  Widget build(BuildContext context) {
    return height == null
        ? Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: color ?? Theme.of(context).dividerColor,
                width: width)),
      ),
    )
        : Container(
      color: color ?? Theme.of(context).dividerColor,
      width: width,
      height: height,
    );
  }
}

void showMyBottomModalSheet(context, Widget widget,
    {Function? onClose, String? title, Color? color}) {
  showModalBottomSheet(
      backgroundColor: color,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16))),
      builder: (builder) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) BottomSheetAppBar(title: title),
            widget
          ],
        );
      }).whenComplete(() {
    onClose?.call();
  });
}

class ClassTag extends StatelessWidget {
  final LectureEventListModel event;
  final bool showBackground;
  const ClassTag(this.event, {Key? key, this.showBackground = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LectureCategoryModel category = event.category;

    return UIKitTag(
      title: category.label,
      tagType: UIKitTagType.custom,
      isSmall: true,
      customForeground: category.fgColor.toColor2(),
      customBackground: showBackground
          ? category.fgColor.toColor2().withOpacity(0.1)
          : category.bgColor.toColor2(),
      icon: SvgPicture.asset(_getIconPath(category.identifier)),
      trailingWidget:
          _isClassLive() ? Lottie.asset(Assets.lottieLivePulse) : null,
    );
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
        iconPath = Assets.svgStar;
    }

    return iconPath;
  }

  bool _isClassLive() {
    final DateTime now = DateTime.now();
    if (event.lectureStartTime != null &&
        event.lectureEndTime != null &&
        event.lectureDate != null) {
      bool isClassLive = false;
      final _dayFormat = DateFormat('yyyy-MM-d');
      final _timeFormat = DateFormat('HH:mm:ss');

      DateTime lectureDate = _dayFormat.parse(event.lectureDate!);
      DateTime lectureStartTime = _timeFormat.parse(event.lectureStartTime!);
      DateTime lectureEndTime = _timeFormat.parse(event.lectureEndTime!);

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

      if (now.isAfter(lectureStartDateTime) &&
          now.isBefore(lectureEndDateTime)) {
        isClassLive = true;
      }
      return isClassLive;
    }
    return false;
  }
}
