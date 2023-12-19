import 'package:admin_hub_app/modules/subjects/ui/widgets/term_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/data/student/models/terms_model.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/subjects_controller.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/widgets/term_filter.dart';
// import 'package:hub/widgets/reusables.dart';

import '../../../../theme/colors.dart';
import '../../../../widgets/reusables.dart';
import '../../data/terms_model.dart';

class ProgramCard extends StatelessWidget implements PreferredSizeWidget {

  ProgramCard({
    Key? key,
    this.leadingText,
    this.terms = const [],
    this.currentTerm = 0,
    this.fetchedTerm,
    required this.onFilterSelected,
    this.dropDownColor = HubColor.purpleAccent2
  }) : super(key: key);

  final String? leadingText;
  final List<Terms> terms;
  final int currentTerm;
  final Terms? fetchedTerm;
  final Function(Terms term) onFilterSelected;
  final Color dropDownColor;
  static const _termLoadingMessage = 'Loading';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          Text(
            leadingText ?? '',
            style: context.textTheme.headline5
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: HubColor.secondaryText),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              showMyBottomModalSheet(
                context,
                TermFilterSheet(
                  terms: terms,
                  currentTerm: currentTerm,
                  fetchedTerm: fetchedTerm,
                  onFilterSelected: onFilterSelected,
                ),
              );
            },
            borderRadius: BorderRadius.circular(4),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: dropDownColor.withOpacity(0.2),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      fetchedTerm?.label ?? _termLoadingMessage,
                      style: context.textTheme.subtitle2
                          ?.copyWith(fontSize: 12, color: HubColor.iconColorCircle),
                    ),
                    Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,

                        color: HubColor.iconColorCircle
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
