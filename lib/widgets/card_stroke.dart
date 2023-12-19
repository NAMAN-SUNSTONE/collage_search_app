import 'package:flutter/material.dart';

import '../theme/colors.dart';
// import 'package:hub/theme/colors.dart';

class CardStroke extends StatelessWidget {
  const CardStroke({this.strokeColor, this.bgColor, required this.child});

  final Color? strokeColor;
  final Color? bgColor;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: strokeColor ?? HubColor.grey1.withOpacity(.1), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: child,
      );
}
