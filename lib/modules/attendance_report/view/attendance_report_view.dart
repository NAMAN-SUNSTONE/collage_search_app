import 'dart:io';

import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';
import 'package:admin_hub_app/modules/attendance_report/view/attendance_report_controller.dart';
import 'package:admin_hub_app/modules/calendar/data/taught_lecture_model.dart';
import 'package:admin_hub_app/modules/calendar/ui/widgets/taught_lecture_list_item.dart';
import 'package:admin_hub_app/modules/schedule/schedule_view.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/theme/size.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:admin_hub_app/widgets/buttons.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:admin_hub_app/widgets/ss_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class AttendanceReportView extends GetView<AttendanceReportController> {
  const AttendanceReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: HubColor.grey1.withOpacity(0.2)));

    return WillPopScope(
      onWillPop: controller.onPop,
      child: Scaffold(
          appBar: SHAppBar(
            title: "Attendance Report",
            actions: [
              GestureDetector(
                onTap: controller.onReset,
                child: Container(
                    alignment: Alignment.center,
                    margin: Sizes.margin,
                    child: Text(
                      'Reset',
                      style: context.textTheme.bodyText2,
                    )),
              )
            ],
          ),
          body: Obx(() => SSLoader.light(
                status: controller.status.value,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: Sizes.marginVertical,
                    child: Column(
                      children: [
                        _Header(),
                        Padding(
                          padding: Sizes.margin,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  flex: 7,
                                  child: SizedBox(
                                    height: 36,
                                    child: TextField(
                                      focusNode: controller.focusNode,
                                      controller:
                                          controller.textFieldController,
                                      decoration: InputDecoration(
                                          hintText: "Search Student",
                                          hintStyle: context.textTheme.bodyText2
                                              ?.copyWith(
                                                  color: HubColor.grey1
                                                      .withOpacity(0.4)),
                                          contentPadding: EdgeInsets.zero,
                                          prefixIcon: Icon(
                                              CupertinoIcons.search,
                                              size: 20,
                                              color: HubColor.grey1
                                                  .withOpacity(0.7)),
                                          suffixIcon: (controller
                                                      .focusNode.hasFocus &&
                                                  controller.textFieldController
                                                      .text.isNotEmpty)
                                              ? GestureDetector(
                                                  onTap:
                                                      controller.onSearchClear,
                                                  child: Icon(
                                                      CupertinoIcons.clear,
                                                      size: 16,
                                                      color: HubColor.grey1
                                                          .withOpacity(0.3)),
                                                )
                                              : null,
                                          border: border,
                                          focusedBorder: border,
                                          focusedErrorBorder: border,
                                          enabledBorder: border),
                                    ),
                                  )),
                              SpaceHorizontal(
                                width: 12,
                              ),
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 36,
                                  child: InkWell(
                                    onTap: controller.onSortButtonClick,
                                    child: controller.isAbsentFirst.value
                                        ? Ink(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    width: 1,
                                                    color: HubColor.grey1
                                                        .withOpacity(0.2))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'A to P  ',
                                                  style: context
                                                      .textTheme.bodyText2
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                SvgPicture.asset(
                                                    Assets.svgArrowUpDown,
                                                    color: HubColor.primary)
                                              ],
                                            ),
                                          )
                                        : Ink(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: HubColor.primary),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'P to A  ',
                                                  style: context
                                                      .textTheme.bodyText2
                                                      ?.copyWith(
                                                          color: HubColor.white,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                SvgPicture.asset(
                                                    Assets.svgArrowUpDown,
                                                    color: HubColor.white)
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 45,
                                child: Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                        value:
                                            controller.allPresentToggle.value,
                                        onChanged: controller.onToggleClick,
                                        activeColor: HubColor.primary)),
                              ),
                              SpaceHorizontal(factor: 0.5),
                              Text(
                                controller.allPresentToggle.value
                                    ? 'All Present'
                                    : "All Absent",
                                style: context.textTheme.caption?.copyWith(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        Space(
                          factor: 2,
                        ),
                        (controller.studentList.isEmpty)
                            ? const Padding(
                                padding: EdgeInsets.only(top: 64),
                                child: Text("No student found"))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: controller.studentList.length,
                                itemBuilder: (bc, i) =>
                                    StudentCard(controller.studentList[i])),
                        Space(
                          factor: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          bottomSheet: Obx(
            () => controller.status.value != Status.success
                ? SizedBox()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          color: controller.event.category?.fgColor
                              .toColor2()
                              .withOpacity(0.1),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              StudentCount(
                                  color: HubColor.green2,
                                  label: 'Total Present',
                                  count:
                                      controller.presentCount.value.toString(),
                                  total: controller.rootList.length.toString()),
                              SpaceHorizontal(),
                              StudentCount(
                                color: HubColor.red,
                                label: 'Total Absent',
                                count: controller.absentCount.value.toString(),
                                total: controller.rootList.length.toString(),
                              ),
                              Spacer(),
                              if (controller.changes.isNotEmpty)
                                GestureDetector(
                                  onTap: controller.onUndoChanges,
                                  child: Text(
                                    'UNDO',
                                    style: context.textTheme.bodyText2
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: HubColor.primary),
                                  ),
                                )
                            ],
                          )),
                      Container(
                        color: HubColor.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: GeneralButton(
                                buttonTextKey: 'Retake',
                                onPressed: controller.onRetake,
                                isBorder: true,
                                elevation: 0,
                                borderColor: HubColor.grey1.withOpacity(0.2),
                                btnbackColor: HubColor.backgroundColor2,
                                textStyle: context.textTheme.button
                                    ?.copyWith(color: HubColor.primary),
                              ),
                            ),
                            SpaceHorizontal(),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: UIKitFilledButton(
                                  text: "Submit",
                                  onPressed: controller.onSubmit,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }
}

class StudentCount extends StatelessWidget {
  final Color color;
  final String label;
  final String count;
  final String total;

  const StudentCount(
      {Key? key,
      required this.color,
      required this.label,
      required this.count,
      required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: context.textTheme.caption
              ?.copyWith(fontSize: 12, color: HubColor.grey1.withOpacity(0.7)),
        ),
        Space(
          height: 4,
        ),
        Row(
          children: [
            Text(
              count,
              style: context.textTheme.caption
                  ?.copyWith(fontWeight: FontWeight.w600, color: color),
            ),
            Text(
              ' / ',
              style: context.textTheme.caption?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              total,
              style: context.textTheme.caption?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        )
      ],
    );
  }
}

class StudentCard extends GetView<AttendanceReportController> {
  final StudentModel student;

  const StudentCard(
    this.student, {
    Key? key,
  }) : super(key: key);

  String getFormattedPhone() {
    if (student.mobile == null) return '';
    final String phone = student.mobile!;
    if (phone.length <= 3) return '';
    return 'XXXX-XX-${phone.substring(phone.length - 4, phone.length)}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool studentPresent = controller.isStudentPresent(student);
      final bool changed = controller.changes.contains(student.studentId);

      return Container(
        padding: Sizes.margin,
        decoration: BoxDecoration(
            color: changed
                ? (studentPresent
                    ? HubColor.green2.withOpacity(0.05)
                    : HubColor.red.withOpacity(0.05))
                : null,
            border: Border(
                bottom: BorderSide(
                    color: HubColor.grey1.withOpacity(0.05), width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.w600, color: HubColor.grey1),
                ),
                Space(
                  height: 4,
                ),
                //todo update phone number
                Text(
                  getFormattedPhone(),
                  style: context.textTheme.caption
                      ?.copyWith(color: HubColor.grey1.withOpacity(0.4)),
                )
              ],
            ),
            ToggleButton(
              isPresent: studentPresent,
              onTap: () => controller.onChange(student),
            )
          ],
        ),
      );
    });
  }
}

class ToggleButton extends StatelessWidget {
  final bool isPresent;
  final void Function()? onTap;

  const ToggleButton({Key? key, required this.isPresent, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color absentColor = HubColor.red;
    final Color presentColor = HubColor.green2;
    final Color disabledColor = HubColor.grey1.withOpacity(0.3);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 28,
            width: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: isPresent ? Border.all(color: presentColor) : null,
                color: isPresent
                    ? presentColor.withOpacity(0.1)
                    : disabledColor.withOpacity(0.05)),
            child: Text(
              'P',
              style: context.textTheme.caption
                  ?.copyWith(color: isPresent ? presentColor : disabledColor),
            ),
          ),
          Container(
              height: 28,
              width: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: isPresent ? null : Border.all(color: absentColor),
                color: isPresent
                    ? disabledColor.withOpacity(0.05)
                    : absentColor.withOpacity(0.1),
              ),
              child: Text(
                'A',
                style: context.textTheme.caption
                    ?.copyWith(color: isPresent ? disabledColor : absentColor),
              ))
        ],
      ),
    );
  }
}

class _Header extends GetView<AttendanceReportController> {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context)
        .textTheme
        .caption
        ?.copyWith(color: HubColor.grey1.withOpacity(0.7));

    return Padding(
      padding: Sizes.marginHorizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClassTag(
                  controller.event,
                  showBackground: true,
                ),
                Space(),
                Text(
                  controller.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(fontSize: 20),
                ),
                const Space(),
                Row(
                  children: [
                    Text(controller.formattedDateTime ?? "", style: style),
                    Container(
                      height: 4,
                      width: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: HubColor.greyIcon,
                      ),
                    ),
                    LectureTimeWidget(
                      lectureDate: controller.event.lectureDate!,
                      startTime: controller.event.lectureStartTime!,
                      endTime: controller.event.lectureEndTime!,
                      textStyle: style,
                    )
                  ],
                ),
                SizedBox(height: 24),
                if (ConnectivityManager.isConnected.value) Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lecture covered in this class', style: UIKitDefaultTypography().subtitle1.copyWith(color: HubColor.grey1)),
                    InkWell(
                        onTap: controller.onTapEditLecture,
                        child: Text('Edit', style: UIKitDefaultTypography().subtitle1.copyWith(fontSize: 12, color: HubColor.primary))),
                  ],
                ),
                if (controller.event.metaData.todayLectures.isNotEmpty) ...[
                  SizedBox(height: 8),
                  TaughtLectureListItem(
                      taughtLecture: TaughtLectureModel(
                          lecture: controller.event.metaData.todayLectures.first,
                          isSelected: true,
                          type: TaughtLectureType.display))
                ]
              ],
            ),
          ),
          if (controller.event.classPictures.isNotEmpty) ...[
            InkWell(
              onTap: () =>
                  controller.onImageClick(controller.event.classPictures.first),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CachedNetworkImage(
                        imageUrl: controller.event.classPictures.first,
                        height: 70,
                        width: 70,
                        fit: BoxFit.fill,
                      ),
                      Container(
                          height: 26,
                          width: 32,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: HubColor.primary),
                          child: Text(
                            controller.event.classPictures.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: HubColor.white,
                                    fontWeight: FontWeight.w600),
                          ))
                    ],
                  )),
            )
    ] else ...[
            if (controller.event.localImages.isNotEmpty)
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(
                        File(controller.event.localImages.first),
                        height: 70,
                        width: 70,
                        fit: BoxFit.fill,
                      ),
                      Container(
                          height: 26,
                          width: 32,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: HubColor.primary),
                          child: Text(
                            controller.event.localImages.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                color: HubColor.white,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  ))
          ]
        ],
      ),
    );
  }
}
