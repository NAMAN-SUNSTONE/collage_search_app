import 'package:admin_hub_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/theme/colors.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class CalendarErrorState extends StatelessWidget {

  const CalendarErrorState({required this.onRetry});

  final void Function() onRetry;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Center(
          child: SvgPicture.asset(
            /*AppSvgPath.calendarError*/''//todo cht
            ,
            width: 104,
            height: 106,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Center(
          child: Text(
            'Something went wrong!',
            style: UIKitDefaultTypography().bodyText2.copyWith(
                fontWeight: FontWeight.w700,
                color: HubColor.calendarEmptyStateTitle),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Center(
          child: Text('We are resolving it, Hold tight.',
              style: UIKitDefaultTypography().bodyText2.copyWith(
                  fontWeight: FontWeight.w500,
                  color: HubColor.calendarEmptyStateSubtitle)),
        ),
        Spacer(),
        SizedBox(
            width: double.infinity,
            height: 48,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: UIKitOutlineButton(
                    text: 'Retry',
                    onPressed: onRetry,
                    buttonSize: UIKitButtonSize.large))),
        SizedBox(height: 16)
      ],
    ),
  );
}