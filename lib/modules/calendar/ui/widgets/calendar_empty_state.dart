import 'package:admin_hub_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:sunstone_ui_kit/ui_kit.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? description;

  //Todo: add generic icon
  final String svgIconPath;

  const EmptyState(
      {Key? key,
      this.title = "Something went wrong!",
      required this.description,
      required this.svgIconPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (svgIconPath != null) ...[
        Center(
          child: SvgPicture.asset(
            svgIconPath!,
            color: HubColor.calendarEmptyStateIcon,
            height: 91,
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
      Center(
        child: Text(
          title,
          style: UIKitDefaultTypography().bodyText2.copyWith(
              fontWeight: FontWeight.w700,
              color: HubColor.calendarEmptyStateTitle),
        ),
      ),
      if (description != null) ...[
        SizedBox(
          height: 2,
        ),
        Center(
          child: Text(description!,
              style: UIKitDefaultTypography().bodyText2.copyWith(
                  fontWeight: FontWeight.w500,
                  color: HubColor.calendarEmptyStateSubtitle)),
        ),
      ]
    ],
  );
  }
}
