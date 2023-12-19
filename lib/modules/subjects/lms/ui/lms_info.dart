import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/lms/lms_controller.dart';
// import 'package:hub/data/student/models/class_count_model.dart';
//
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/course_detail/widget/faculty_cards.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/course_detail/widget/recent_classes.dart';
// import 'package:hub/ui/timetable/scheduler/notes/view/notes_view.dart';
// import 'package:hub/widgets/reusables.dart';
// import 'package:pie_chart/pie_chart.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../../../theme/colors.dart';
import '../../../../widgets/reusables.dart';
import '../../data/class_count_model.dart';
import '../../ui/course_detail/widget/faculty_cards.dart';
import '../../ui/course_detail/widget/recent_classes.dart';
import '../lms_controller.dart';

class LmsInfo extends GetView<LmsController> {
  const LmsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> attachments =
        controller.academicContentData!.attachments;

    Widget buildSection(String title, Widget child,
        {bool visibility = true,
        EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16)}) {
      if (!visibility) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: context.textTheme.headline5
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: padding,
            child: child,
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.academicContentData!.recentClasses?.isNotEmpty ??
                false)
              buildSection(
                  'Upcoming Classes',
                  RecentClasses(
                    recentClasses:
                        controller.academicContentData!.recentClasses!,
                  ),
                  padding: EdgeInsets.zero),
            // if (controller.academicContentData!.attendanceCount != null)
            //   buildSection(
            //       'Course Attendance',
            //       AttendanceSubjectCard(
            //         onPressed: () {
            //           debugPrint('Course Attendance click');
            //         },
            //         showLearnMore: false,
            //         classCount:
            //             controller.academicContentData!.attendanceCount!,
            //       )),
            if (controller.academicContentData!.description?.isNotEmpty ??
                false)
              DescriptionTile(
                tile: "Course Overview",
                description: controller.academicContentData!.description!,
                hideDivider: true,
              ),
            if (controller.academicContentData!.professors?.isNotEmpty ?? false)
              buildSection(
                  'Faculty',
                  ConnectWithYourFaculty(
                      faculties: controller.academicContentData!.professors!)),
            if (attachments.isNotEmpty)
              AttachmentListView(
                  urlList: List.generate(
                      attachments.length, (index) => attachments[index])),
            Space(
              factor: 8,
            )
          ],
        ),
      ),
    );
  }
}

class AttachmentListView extends StatelessWidget {
  final List<String> urlList;

  const AttachmentListView({Key? key, required this.urlList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double size = 104;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attachments',
            style: UIKitDefaultTypography()
                .headline6
                .copyWith(color: HubColor.grey1)),
        SpaceLarge(),
        SizedBox(
          height: size,
          child: ListView.separated(
              itemCount: urlList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(right: 16),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 16,
                );
              },
              itemBuilder: (context, index) {
                final String url = urlList[index];
                return SizedBox(
                    width: size,
                    /*child: ViewAttachment(
                      url,
                      disableDelete: true,
                      onClick: (fileName, fileType) {},
                    )*/);
              }),
        ),
      ],
    );
  }
}

class DescriptionTile extends StatelessWidget {
  final String tile;
  final String description;
  final bool hideDivider;

  const DescriptionTile(
      {Key? key,
      required this.tile,
      required this.description,
      this.hideDivider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tile,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HubColor.grey1),
          ),
          Space(
            height: 4,
          ),
          Text(
              description.replaceAll(
                r'\n',
                '\n',
              ),
              style: UIKitDefaultTypography()
                  .subtitle2
                  .copyWith(color: HubColor.grey1.withOpacity(0.7), fontSize: 14)),
          !hideDivider
              ? CustomDivider(
                  top: 20,
                  bottom: 20,
                )
              : const SizedBox(
                  height: 24,
                ),
        ],
      ),
    );
  }
}

class AttendanceSubjectCard extends StatelessWidget {
  const AttendanceSubjectCard(
      {Key? key,
      required this.classCount,
      required this.onPressed,
      this.showLearnMore = true})
      : super(key: key);

  final ClassCount classCount;
  final Function? onPressed;
  final bool showLearnMore;

  @override
  Widget build(BuildContext context) {
    int totalClasses =
        classCount.present + classCount.absent + classCount.unmarked;
    Map<String, double> dMap = {
      "Absent": 0,
      "Unmarked": 0,
      "Present": 100,
    };
    double presentPercentage = 100;
    if (totalClasses != 0) {
      dMap = {
        "Absent": (classCount.absent / totalClasses) * 100,
        "Unmarked": (classCount.unmarked / totalClasses) * 100,
        "Present": (classCount.present / totalClasses) * 100,
      };
      presentPercentage = (classCount.present / totalClasses) * 100;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    color: HubColor.white,
                    border: Border.all(
                      color: Color(0xffECECEC),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 2),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 0.0),
                                      visualDensity: VisualDensity(
                                          horizontal: 2, vertical: -4),
                                      minLeadingWidth: 12,
                                      leading: Container(
                                        color: Color(0xff2B9A1B),
                                        height: 6,
                                        width: 6,
                                      ),
                                      title: Text(
                                        'Attended',
                                        style: context.textTheme.bodyText2
                                            ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: HubColor.grey6),
                                      ),
                                      trailing: Text(
                                        classCount.present.toString(),
                                        style: context.textTheme.bodyText2
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: HubColor.grey6),
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 0.0),
                                      visualDensity: VisualDensity(
                                          horizontal: 2, vertical: -4),
                                      minLeadingWidth: 12,
                                      leading: Container(
                                        color: Color(0xffDC5343),
                                        height: 6,
                                        width: 6,
                                      ),
                                      title: Text(
                                        'Absent',
                                        style: context.textTheme.bodyText2
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: HubColor.grey6),
                                      ),
                                      trailing: Text(
                                        classCount.absent.toString(),
                                        style: context.textTheme.bodyText2
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: HubColor.grey6),
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 0.0),
                                      visualDensity: VisualDensity(
                                          horizontal: 2, vertical: -4),
                                      minLeadingWidth: 12,
                                      leading: Container(
                                        color: Color(0xffEF9E38),
                                        height: 6,
                                        width: 6,
                                      ),
                                      title: Text(
                                        'Unmarked',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodyText2
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: HubColor.grey6),
                                      ),
                                      trailing: Text(
                                        classCount.unmarked.toString(),
                                        style: context.textTheme.bodyText2
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: HubColor.grey6),
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 0.0),
                                      visualDensity: VisualDensity(
                                          horizontal: 2, vertical: -4),
                                      title: Text(
                                        'Total Classes',
                                        style: context.textTheme.caption
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: HubColor.grey4),
                                      ),
                                      trailing: Text(
                                        totalClasses.toString(),
                                        style: context.textTheme.caption
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: HubColor.grey4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              if (totalClasses != 0)
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // child: PieChart(
                                    //   dataMap: dMap,
                                    //   animationDuration:
                                    //       Duration(milliseconds: 800),
                                    //   chartLegendSpacing: 32,
                                    //   chartRadius:
                                    //       MediaQuery.of(context).size.width /
                                    //           3.3,
                                    //   initialAngleInDegree: 0,
                                    //   chartType: ChartType.ring,
                                    //   ringStrokeWidth: 14,
                                    //   centerText: presentPercentage
                                    //           .truncate()
                                    //           .toString() +
                                    //       "%",
                                    //   legendOptions: LegendOptions(
                                    //     showLegendsInRow: false,
                                    //     legendPosition: LegendPosition.right,
                                    //     showLegends: false,
                                    //     legendShape: BoxShape.circle,
                                    //     legendTextStyle: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    //   chartValuesOptions: ChartValuesOptions(
                                    //     showChartValueBackground: false,
                                    //     showChartValues: false,
                                    //     showChartValuesInPercentage: false,
                                    //     showChartValuesOutside: false,
                                    //     decimalPlaces: 1,
                                    //   ),
                                    //   colorList: [
                                    //     Color(0xffDC5343),
                                    //     Color(0xffEF9E38),
                                    //     Color(0xff2B9A1B),
                                    //   ],
                                    //   centerTextStyle: context.textTheme.button
                                    //       ?.copyWith(
                                    //           fontSize: 20,
                                    //           color: HubColor.grey6),
                                    // ),
                                  ),
                                ),
                              if (totalClasses == 0) Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
