import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/widgets/card_stroke.dart';
import 'package:flutter/material.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

class SSTile extends StatelessWidget {
  const SSTile({this.leading, required this.title, this.trailing, this.onTap});

  final Widget? leading;
  final String title;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: CardStroke(
            bgColor: HubColor.white,
            strokeColor: HubColor.cardStroke,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                children: [
                  if (leading != null) ...[leading!, SizedBox(width: 10)],
                  Text(title,
                      style: UIKitDefaultTypography()
                          .bodyText2
                          .copyWith(overflow: TextOverflow.ellipsis),
                      maxLines: 1),
                  if (trailing != null) ...[Spacer(), trailing!]
                ],
              ),
            )),
      );
}
