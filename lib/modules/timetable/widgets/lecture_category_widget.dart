import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hub/app_assets/app_svg_path.dart';

class LectureCategory {
  final String name;
  final String value;
  final Color bgColor;
  final Color fgColor;
  final String? svg;
  LectureCategory(
      {required this.name,
      required this.value,
      required this.bgColor,
      required this.fgColor,this.svg});
}

class LectureCategoryWidget extends StatelessWidget {
  const LectureCategoryWidget({
    Key? key,
    required this.lectureCategory,
  }) : super(key: key);

  final LectureCategory lectureCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: lectureCategory.bgColor,
        borderRadius: BorderRadius.circular(
          14,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            child: SvgPicture.asset(
                lectureCategory.svg ?? _getIconPath(lectureCategory.name),
              color: lectureCategory.fgColor,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            lectureCategory.name,
            style: context.textTheme.caption?.copyWith(
              color: lectureCategory.fgColor,
            ),
          ),
        ],
      ),
    );
  }

  //Get Iconn PATH depending on lecture Category
  String _getIconPath(String lectureCategory) {
    String iconPath = AppSvgPath.circle;
    switch (lectureCategory.toLowerCase()) {
      case 'class':
        iconPath = AppSvgPath.circle;
        break;

      case 'bootcamp':
        iconPath = AppSvgPath.triangle;
        break;
      case 'webinar':
        iconPath = AppSvgPath.star;
        break;
      default:
    }

    return iconPath;
  }
}
