import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../data/terms_model.dart';
// import 'package:hub/data/student/models/terms_model.dart';
// import 'package:hub/theme/colors.dart';

class TermFilterItem extends StatelessWidget {
  const TermFilterItem({Key? key,
    required this.trimester,
    required this.selected,
    required this.termNo,
    required this.onPressed,
    this.selectedColor
  }) : super(key: key);

  final Terms trimester;
  final bool selected;
  final int termNo;
  final Function(Terms) onPressed;
  final Color? selectedColor;

  //Constants
  static const String upcomingTermMessage = 'Yet to Start';

  //Values
  bool get isPastTerm => trimester.termNo <= termNo;

  //UI
  Color get disabledColor => HubColor.grey1.withOpacity(0.3);

  Color get titleColor {
    if (!isPastTerm) return disabledColor;
    if (selected) return HubColor.primary;

    return HubColor.grey1;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isPastTerm
          ? () {
        onPressed(trimester );
        Navigator.of(context).pop();
      }
          : null,
      child: Container(
        height: 51,
        color: selected ? selectedColor ?? HubColor.purpleAccent2.withOpacity(0.2) : null,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              trimester.label,
              style: context.textTheme.bodyText1?.copyWith(
                fontSize: 14,
                color: titleColor,
              ),
            ),
            const Spacer(),
            if (!isPastTerm)
              Text(
                upcomingTermMessage,
                style:
                context.textTheme.caption?.copyWith(color: disabledColor),
              )
          ],
        ),
      ),
    );
  }
}
