import 'package:flutter/material.dart';
// import 'package:hub/theme/colors.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../../theme/colors.dart';

class NextPrevButton extends StatelessWidget {
  final bool hideBack;
  final bool hideNext;
  final Function? onBackTap;
  final Function? onNextTap;
  final String? trailingText;
  final bool hideIcons;
  final String? prevLabel;
  final String? nextLabel;

  NextPrevButton(
      {Key? key,
        this.hideBack = true,
        this.hideNext = false,
        this.onBackTap,
        this.onNextTap,
        this.hideIcons = false,
        this.trailingText,
        this.prevLabel,
        this.nextLabel
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
      !hideBack ?
          Expanded(
            child:
                 InkWell(
              onTap: () {
                onBackTap?.call();
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(hideIcons)...[
                    Icon(
                      Icons.arrow_back_ios,
                      size: 11,
                      color: HubColor.primary,
                    ),
                    SizedBox(
                      width: 12,
                    ),
    ],
                    Text(
                     prevLabel ?? 'Previous',
                      style: UIKitDefaultTypography().bodyText1.copyWith(
                          color: HubColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            )

          )  : SizedBox.shrink(),

          if(!hideBack && !hideNext)
            SizedBox(
              width: 8,
            ),


          !hideNext?
             Expanded(
            child:InkWell(
              onTap: () {
                onNextTap?.call();
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: HubColor.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(width: 16,),

                    Text(
                      nextLabel ?? 'Next',
                      style: UIKitDefaultTypography().bodyText1.copyWith(
                          color: HubColor.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 12,
                    ),


                    if(trailingText != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          trailingText!,
                          style: UIKitDefaultTypography().subtitle1.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: HubColor.lightPurpleGrey),
                        ),
                      ),
                    ),

                if(hideIcons)...[

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: HubColor.white,
                    ),
                ],

                  ],
                ),
              ),
            )
          ): SizedBox.shrink(),
        ],
      ),
    );
  }
}
