import 'package:admin_hub_app/modules/content_view/target_model.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/general_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hub/data/student/models/target_model.dart';
// import 'package:hub/theme/colors.dart';
import 'package:get/get.dart';
// import 'package:hub/utils/general_operations.dart';
// import 'package:hub/utils/navigator/navigator.dart';

class SingelRowTextWidget extends StatelessWidget {
  const SingelRowTextWidget(
      {Key? key,
      this.icon,
      required this.value,
      this.valueTextColor = HubColor.grey1,
      this.valueTextFontSize = 14,
      this.valueTextdecoration,
      this.isTextClickable = false,
      this.isTextCopiable = false,
      this.textAlign,
      this.onTap,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.svgIconPath,
      this.enableHyperLink = false})
      : super(key: key);
  final IconData? icon;
  final String value;
  final Color valueTextColor;
  final double valueTextFontSize;
  final TextDecoration? valueTextdecoration;
  final bool isTextClickable;
  final bool isTextCopiable;
  final TextAlign? textAlign;
  final void Function()? onTap;
  final CrossAxisAlignment crossAxisAlignment;
  final String? svgIconPath;
  final bool enableHyperLink;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        RowIcon(
          icon: icon,
          svgIconPath: svgIconPath,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onTap: () async {
              if (isTextClickable && onTap != null) {
                onTap!();
              }
            },
            onLongPress: () async {
              if (isTextCopiable) {
                await GeneralOperations.copyToClipBoardString(value);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 6.5),
              child: enableHyperLink
                  ? Linkify(
                      onOpen: (LinkableElement link) {
                        Target target = Target(
                            identifier: Identifiers.open_deeplink,
                            value: '',
                            title: '',
                            redirectUrl: link.url);
                        // SHNavigationManager.navigate(target); //todo cht
                      },
                      text: value,
                      style: context.textTheme.bodyText1?.copyWith(
                          decoration: valueTextdecoration,
                          fontSize: valueTextFontSize,
                          color: valueTextColor,
                          fontWeight: FontWeight.w400,
                          height: 16.8 / valueTextFontSize),
                    )
                  : Text(
                      value,
                      style: context.textTheme.bodyText1?.copyWith(
                          decoration: valueTextdecoration,
                          fontSize: valueTextFontSize,
                          color: valueTextColor,
                          fontWeight: FontWeight.w400,
                          height: 16.8 / valueTextFontSize),
                      textAlign: textAlign,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class RowIcon extends StatelessWidget {
  const RowIcon({Key? key, this.svgIconPath, this.icon}) : super(key: key);
  final String? svgIconPath;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (svgIconPath == null && icon == null) {
      return const SizedBox.shrink();
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: HubColor.primaryTint,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: svgIconPath != null
            ? SizedBox(
                height: 16,
                width: 16,
                child: SvgPicture.asset(
                  svgIconPath!,
                  height: 16,
                  width: 16,
                ))
            : Icon(
                icon,
                color: HubColor.iconColor,
                size: 16,
              ),
      ),
    );
  }
}
