import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/datetime_extension.dart';
import 'package:flutter/cupertino.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class DateIndicator extends StatelessWidget {
  DateIndicator({required this.date, required this.isSelected});

  final DateTime date;
  final bool isSelected;

  final DateFormat _dateFormat = DateFormat("dd");
  final DateFormat _monthFormat = DateFormat("MMM");

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          children: [
            DateTime.now().isSameDate(date)
                ? Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HubColor.primary,
                    ),
                    child: Text(_dateFormat.format(date),
                        style: UIKitDefaultTypography().headline1.copyWith(
                            fontSize: 12, color: HubColor.white, height: 1.0)))
                : Text(_dateFormat.format(date),
                    style: UIKitDefaultTypography().headline1.copyWith(
                        fontSize: 12, color: HubColor.primary, height: 1.0)),
            SizedBox(height: 4),
            Text(_monthFormat.format(date),
                style: UIKitDefaultTypography()
                    .bodyText2
                    .copyWith(color: HubColor.primary, height: 1.0)),
          ],
        ),
      ),
    );
  }
}
