import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hub/data/filter_general/models/filter_category_model.dart';
import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
import 'package:hub/theme/colors.dart';
import 'package:hub/ui/timetable/scheduler/widgets/single_filter_widget.dart';

class FilterScheduler extends StatelessWidget {
  final List<FilterCategoryModel> filterList;
  final Function(int categoryIndex, int filterIndex, bool? newVal)
      onChangeFilterValue;
  final Function(int categoryIndex, bool? newVal) onChangeCategoryValue;

  FilterScheduler(
      {required this.filterList,
      required this.onChangeFilterValue,
      required this.onChangeCategoryValue});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        // height: 560,
        padding: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: HubColor.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BottomSheetAppBar(title: 'Filters'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'VIEW EVENTS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                ..._getFilterList(filterList),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _getFilterList(List<FilterCategoryModel> filterList) {
    List<Widget> _filterCategoryWidgetList = [];

    for (var i = 0; i < filterList.length; i++) {
      _filterCategoryWidgetList.add(SingelFilterWidget(
          filterCategoryModel: filterList[i],
          categroyIndex: i,
          onChangeFilterValue: onChangeFilterValue,
          onChangeCategoryValue: onChangeCategoryValue));
    }
    return _filterCategoryWidgetList;
  }
}
