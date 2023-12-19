import 'package:admin_hub_app/modules/subjects/ui/widgets/term_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../../../widgets/ss_appbar.dart';
import '../../data/terms_model.dart';
// import 'package:hub/data/student/models/terms_model.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/subjects_controller.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/widgets/term_filter_item.dart';
// import 'package:hub/widgets/reusables.dart';

class TermFilterSheet extends StatelessWidget {
  const TermFilterSheet({
    Key? key,
    this.terms = const [],
    this.currentTerm = 0,
    this.fetchedTerm,
    required this.onFilterSelected,
    this.selectedColor
  }) : super(key: key);

  final List<Terms> terms;
  final int currentTerm;
  final Terms? fetchedTerm;
  final Function(Terms value ) onFilterSelected;
  final Color? selectedColor;


  static const _bottomSheetTitle = 'Select Term';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BottomSheetAppBar(
          title: _bottomSheetTitle,
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: context.height * .7,
          ),
          child: ListView.separated(
              itemCount: terms.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, index) {
                return const Divider(
                  height: 1,
                  color: HubColor.dividerColorEF,
                );
              },
              itemBuilder: (_, index) {
                return TermFilterItem(
                  trimester: terms[index],
                  selected: fetchedTerm!.termNo - 1 == index,
                  termNo: currentTerm,
                  onPressed: onFilterSelected,
                  selectedColor: selectedColor,
                );
              }),
        )
      ],
    );
  }
}
