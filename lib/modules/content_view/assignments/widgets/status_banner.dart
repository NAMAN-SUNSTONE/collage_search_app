import 'package:admin_hub_app/utils/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/datetime_extension.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../../../theme/colors.dart';
import '../../../attendance_report/model/academic_content_model.dart';

class AssignmentStatusBanner extends StatelessWidget {
  final LmsAssessmentModel assignment;

  const AssignmentStatusBanner({Key? key, required this.assignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (assignment.status == AssignmentStatus.Graded) {
      return GradedStatusBanner(
        assignment: assignment,
      );
    } else if (assignment.status == AssignmentStatus.Pending) {
      return AssignmentStatusBaseBanner(
        backgroundColor: HubColor.yellowExtraLight,
        textColor: HubColor.iconColorStar,
        date: assignment.deadlineDate,
        status: assignment.status,
      );
    } else if (assignment.status == AssignmentStatus.Submitted) {
      return AssignmentStatusBaseBanner(
        backgroundColor: HubColor.blue4.withOpacity(0.2),
        textColor: HubColor.blue4,
        date: assignment.submittedDate,
        status: assignment.status,
      );
    } else if (assignment.status == AssignmentStatus.Overdue) {
      return OverdueStatusBanner(assignment: assignment);
    }

    return SizedBox.shrink();
  }
}

class AssignmentStatusBaseBanner extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color? statusTextColor;
  final AssignmentStatus? status;
  final DateTime? date;

  const AssignmentStatusBaseBanner(
      {Key? key,
      required this.textColor,
      required this.backgroundColor,
      required this.status,
      this.statusTextColor,
      required this.date})
      : super(key: key);

  String get getReadableDate {
    if (date == null) {
      return '';
    } else {
      return date!.toReadableDate(showTime: false) ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String statusText = status!.name.capitalizeFirst ?? 'NA';

    return Column(
      children: [
        Container(
            height: 50,
            width: double.infinity,
            color: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              // AssignmentStatusBadge(status:status,),
              if (date != null) ...[
                // Spacer(),
                Text('Due date: $getReadableDate',
                    style: UIKitDefaultTypography().subtitle2.copyWith(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]
            ])),
      ],
    );
  }
}


class AssignmentStatusBadge extends StatelessWidget {
  final AssignmentStatus? status;

  const AssignmentStatusBadge({Key? key, required this.status})
      : super(key: key);

  Color getTextColor() {
    if (status == AssignmentStatus.Graded) {
      return HubColor.green5;
    } else if (status == AssignmentStatus.Pending) {
      return HubColor.iconColorStar;
    } else if (status == AssignmentStatus.Submitted) {
      return HubColor.blue4;
    } else if (status == AssignmentStatus.Overdue) {
      return HubColor.error2;
    }

    return HubColor.iconColorStar;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          color: HubColor.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Text(status.toString().split('.').last,
              style: UIKitDefaultTypography().subtitle2.copyWith(
                  color: getTextColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ));
  }
}

class GradedStatusBanner extends StatelessWidget {
  final LmsAssessmentModel assignment;

  const GradedStatusBanner({Key? key, required this.assignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentStatusBaseBanner(
          backgroundColor: HubColor.green5,
          textColor: HubColor.white,
          date: assignment.gradedDate,
          status: assignment.status,
          statusTextColor: HubColor.green5,
        ),
        // Container(
        //   width: double.infinity,
        //   color: HubColor.greenTint2.withOpacity(0.2),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           "Grade: ${assignment.obtainedGrade ?? ''}/${assignment.maxGrade ?? 'NA'}",
        //           style: UIKitDefaultTypography().headline5.copyWith(
        //               fontSize: 16,
        //               fontWeight: FontWeight.w700,
        //               color: HubColor.green5),
        //         ),
        //         if (assignment.remarks != null) ...[
        //           SizedBox(
        //             height: 8,
        //           ),
        //           Text(
        //             'Comment:',
        //             style: UIKitDefaultTypography().subtitle2.copyWith(
        //                   color: HubColor.hintText,
        //                 ),
        //           ),
        //           Text(
        //             assignment.remarks!,
        //             style: UIKitDefaultTypography()
        //                 .headline5
        //                 .copyWith(fontSize: 12),
        //           )
        //         ]
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}

class OverdueStatusBanner extends StatelessWidget {
  final LmsAssessmentModel assignment;

  const OverdueStatusBanner({Key? key, required this.assignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentStatusBaseBanner(
          backgroundColor: HubColor.error2,
          textColor: HubColor.white,
          date: assignment.deadlineDate,
          status: assignment.status,
          statusTextColor: HubColor.error2,
        ),
        // Container(
        //   width: double.infinity,
        //   color: HubColor.greenTint2.withOpacity(0.2),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           assignment.remarks ?? 'Overdue',
        //           style: UIKitDefaultTypography()
        //               .headline5
        //               .copyWith(fontSize: 12),
        //         )
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
