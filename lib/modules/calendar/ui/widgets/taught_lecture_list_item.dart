import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/calendar/data/taught_lecture_model.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/widgets/card_stroke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

class TaughtLectureListItem extends StatelessWidget {
  const TaughtLectureListItem({required this.taughtLecture, this.onTap});

  final TaughtLectureModel taughtLecture;
  final Function(TaughtLectureModel)? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onTap?.call(taughtLecture),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: ShapeDecoration(
            color: (taughtLecture.type == TaughtLectureType.regular ||
                    taughtLecture.type == TaughtLectureType.display)
                ? HubColor.purple2.withAlpha(51)
                : HubColor.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: (taughtLecture.type == TaughtLectureType.regular ||
                        taughtLecture.type == TaughtLectureType.display)
                    ? HubColor.purple2.withAlpha(127)
                    : HubColor.white,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (taughtLecture.type != TaughtLectureType.display) ...[
                  SvgPicture.asset(taughtLecture.isSelected
                      ? Assets.svgRadioChecked
                      : Assets.svgRadioUnchecked, width: 16, height: 16),
                  SizedBox(width: 8)
                ],
                Expanded(
                  child: Text(taughtLecture.lecture.title,
                      style: UIKitDefaultTypography().subtitle1.copyWith(
                          color: HubColor.iconColorCircle, height: 1.1)),
                )
              ],
            ),
          ),
        ),
      );
}
