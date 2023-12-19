import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hub/app_assets/app_svg_path.dart';
import 'package:hub/data/filter_general/models/filter_category_model.dart';
import 'package:hub/data/filter_general/models/single_filter_model.dart';
import 'package:hub/theme/colors.dart';
import 'package:hub/ui/timetable/widgets/lecture_category_widget.dart';
import 'package:hub/utils/color_extension.dart';

class IconPathandColor {
  final String iconPath;
  final Color iconColor;
  final Color iconColorBackground;

  IconPathandColor(
      {required this.iconPath,
      required this.iconColor,
      required this.iconColorBackground});
}

class SingelFilterWidget extends StatelessWidget {
  const SingelFilterWidget(
      {Key? key,
      required this.filterCategoryModel,
      required this.categroyIndex,
      required this.onChangeFilterValue,
      required this.onChangeCategoryValue})
      : super(key: key);

  final FilterCategoryModel filterCategoryModel;
  final int categroyIndex;
  final Function(int categoryIndex, int filterIndex, bool? newVal)
      onChangeFilterValue;
  final Function(int categoryIndex, bool? newVal) onChangeCategoryValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          activeColor: HubColor.primary,
          value: filterCategoryModel.isSelcted,
          onChanged: (value) {
            onChangeCategoryValue(categroyIndex, value);
          },
        ),
        // SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _singleCategoryWidget(
                  filterCategoryModel.label, filterCategoryModel.identifier),
              ..._getFilterWidget(
                  context, filterCategoryModel.singleFilterModel),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _getFilterWidget(
      BuildContext context, List<SingleFilterModel> filterList) {
    List<Widget> filterWidgetList = [];

    for (var i = 0; i < filterList.length; i++) {
      filterWidgetList.add(_singleFilterWidget(
          context: context,
          filterLabel: filterList[i].label,
          myIndex: i,
          crossAxisAligmment: i == (filterList.length - 1)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
          myVal: filterList[i].isSelected));
    }

    return filterWidgetList;
  }

  Widget _singleCategoryWidget(
    String categoryLabel,
    String categoryIdentifier,
  ) {
    IconPathandColor iconPathColor = _getIconPath(categoryIdentifier);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: LectureCategoryWidget(
        lectureCategory: LectureCategory(
          name: categoryLabel,
          value: categoryIdentifier,
          svg: iconPathColor.iconPath,
          bgColor: iconPathColor.iconColorBackground,
          fgColor: iconPathColor.iconColor,
        ),
      ),
    );
  }

  Widget _singleFilterWidget(
      {required BuildContext context,
      required String filterLabel,
      required int myIndex,
      required bool myVal,
      CrossAxisAlignment crossAxisAligmment = CrossAxisAlignment.center}) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAligmment,
        children: [
          const VerticalDivider(
            thickness: 1,
            color: HubColor.greyDC,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 17,
              left: 9,
              right: 12,
            ),
            child: SizedBox(
              height: 18,
              width: 18,
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: HubColor.primary,
                value: myVal,
                onChanged: (value) {
                  onChangeFilterValue(categroyIndex, myIndex, value);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 17,
            ),
            child: Text(
              filterLabel,
              style: context.textTheme.bodyText2
                  ?.copyWith(color: HubColor.black2A),
            ),
          ),
        ],
      ),
    );
  }

  IconPathandColor _getIconPath(String categroyIdentifier) {
    IconPathandColor iconPathColor = IconPathandColor(
        iconPath: AppSvgPath.circle,
        iconColor: HubColor.iconColorCircle,
        iconColorBackground: HubColor.iconColorCircleLight);

    switch (categroyIdentifier.toLowerCase()) {
      case 'academic':
        iconPathColor = IconPathandColor(
            iconPath: AppSvgPath.circle,
            iconColor: HubColor.iconColorCircle,
            iconColorBackground: HubColor.iconColorCircleLight);
        break;

      case 'training':
        iconPathColor = IconPathandColor(
            iconPath: AppSvgPath.triangle,
            iconColor: HubColor.iconColorTriangle,
            iconColorBackground: HubColor.iconColorTriangleLight);

        break;
      case 'extra-curricular':
        iconPathColor = IconPathandColor(
            iconPath: AppSvgPath.star,
            iconColor: HubColor.iconColorStar,
            iconColorBackground: HubColor.iconColorStarLight);

        break;
      default:
    }

    return iconPathColor;
  }
}
