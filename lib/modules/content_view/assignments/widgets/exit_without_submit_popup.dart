import 'package:flutter/material.dart';

import 'package:get/get_utils/get_utils.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/widgets/buttons.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../../../theme/colors.dart';
import '../../../../widgets/buttons.dart';

class ExitWithoutSubmit extends StatelessWidget {
  final String title;
  final String? description;
  final String? cancelText;
  final String? yesText;
  final Function? onCancel;
  final Function? onYes;

  const ExitWithoutSubmit({Key? key, this.onCancel,
    this.onYes,
    this.title = 'You haven’t submit content',
    this.description,
    this.cancelText,
    this.yesText,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error, size: 26, color: HubColor.redNormal),
              SizedBox(
                width: 8,
              ),
              Text(
                title,
                style:
                UIKitDefaultTypography().headline1.copyWith(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if (description != null)
          Text(description!),
          Container(
            height: 130,
            width: context.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: context.width,
                  child: GeneralButton(
                    buttonTextKey: yesText ?? 'Continue',
                    onPressed: () {
                      onYes?.call();
                      Navigator.of(context).pop();
                    },
                    elevation: 0,
                    textStyle: context.textTheme.button?.copyWith(
                        color: HubColor.backgroundColor2,
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                SizedBox(
                width: context.width,
                  child: GeneralButton(
                    buttonTextKey: cancelText ?? 'Cancel',
                    onPressed: () {
                      onCancel?.call();
                      Navigator.of(context).pop();
                    },
                    isBorder: true,
                    elevation: 0,
                    borderColor: HubColor.primary,
                    btnbackColor: HubColor.backgroundColor2,
                    textStyle: context.textTheme.button
                        ?.copyWith(color: HubColor.primary, letterSpacing: 0),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
