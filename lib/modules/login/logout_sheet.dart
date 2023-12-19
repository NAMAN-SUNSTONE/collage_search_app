import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/widgets/buttons.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmSheet extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  final String title;
  final String message;

  ConfirmSheet(
      {Key? key,
      required this.onYes,
      required this.onNo,
      this.title = 'Are you sure want to log out?',
      this.message =
          'You’ll be missing out important updates about your Classes, Events and much more.'})
      : super(key: key);

  static const String _yesButtonLabel = 'Yes';
  static const String _noButtonLabel = 'No';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BottomSheetAppBar(
              title: title,
              titleTextStyle: context.textTheme.headline4
                  ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
              centerTitle: false,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              message,
              style: context.textTheme.subtitle1
                  ?.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            SizedBox(
              height: 32,
            ),
            Container(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GeneralButton(
                      buttonTextKey: _yesButtonLabel,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onYes();
                      },
                      isBorder: true,
                      elevation: 0,
                      borderColor: HubColor.grey1.withOpacity(0.2),
                      btnbackColor: HubColor.backgroundColor2,
                      textStyle: context.textTheme.button
                          ?.copyWith(color: HubColor.primary),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: Container(
                      child: GeneralButton(
                        buttonTextKey: _noButtonLabel,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onNo();
                        },
                        elevation: 0,
                        textStyle: context.textTheme.button?.copyWith(
                          color: HubColor.backgroundColor2,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
