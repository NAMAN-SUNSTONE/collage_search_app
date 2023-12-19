import 'package:admin_hub_app/analytics/events/screens/schedule.dart';
import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/calendar/data/taught_lecture_model.dart';
import 'package:admin_hub_app/modules/calendar/ui/widgets/taught_lecture_list_item.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class TaughtLectureList extends GetView<TaughtLectureListController> {
  const TaughtLectureList(
      {required this.event,
      required this.todayLectures,
      required this.otherLectures,
      required this.ctaText,
      this.onTapCta});

  final LectureEventListModel event;
  final List<LectureModel> todayLectures;
  final List<LectureModel> otherLectures;
  final String ctaText;
  final Function(LectureModel)? onTapCta;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: false,
        init: TaughtLectureListController(
            todayLectures: todayLectures,
            otherLectures: otherLectures,
            ctaText: ctaText),
        builder: (TaughtLectureListController controller) {
          return Obx(() {
            List<TaughtLectureModel> list = controller.processList();

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              child: Column(
                children: [
                  controller.isExpanded.value
                      ? SHAppBar(onBackPressed: controller.onTapBack)
                      : BottomSheetAppBar(),
                  Text('Which lecture is being taught for today\'s class?',
                      style: UIKitDefaultTypography()
                          .headline1
                          .copyWith(fontSize: 16)),
                  SizedBox(height: 24),
                  ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) => TaughtLectureListItem(
                          taughtLecture: list[index],
                          onTap: (taughtLecture) => controller.onTapLecture(taughtLecture.lecture)),
                      separatorBuilder: (_, __) => SizedBox(height: 16),
                      itemCount: list.length),
                  SizedBox(height: 12),
                  SizedBox(
                      width: double.infinity,
                      child: UIKitFilledButton(
                          text: ctaText, isEnabled: controller.selectedLecture.value?.id != TaughtLectureListController.otherLecture.id, onPressed: () {
                            SchedulePageEvents().markLecture(event, controller.initialSelectedLecture, controller.selectedLecture.value!);
                            onTapCta?.call(controller.selectedLecture.value!);
                          }))
                ],
              ),
            );
          });
        });
  }
}

class TaughtLectureListController extends BaseController {
  TaughtLectureListController(
      {required this.todayLectures,
      required this.otherLectures,
      required this.ctaText});

  final List<LectureModel> todayLectures;
  final List<LectureModel> otherLectures;
  final String ctaText;

  List<LectureModel> get lectures {
    if (isExpanded.value) return otherLectures;
    return todayLectures;
  }

  RxBool isExpanded = false.obs;
  Rx<LectureModel?> selectedLecture = Rx<LectureModel?>(null);
  late LectureModel initialSelectedLecture;

  static const LectureModel otherLecture =
      LectureModel(id: 0, title: 'Other lecture', content: []);
  static const LectureModel notMentionedLecture =
      LectureModel(id: -1, title: 'Lecture not mentioned here', content: []);

  void onInit() {
    super.onInit();
    _setInitialSelectedItem();
  }

  void _setInitialSelectedItem() {
    if (todayLectures.isNotEmpty) {
      selectedLecture.value = todayLectures.first;
    } else if (otherLectures.isNotEmpty) {
      onTapLecture(otherLecture);
      selectedLecture.value = otherLectures.first;
    } else {
      onTapLecture(otherLecture);
      selectedLecture.value = notMentionedLecture;
    }
    initialSelectedLecture = selectedLecture.value!;
  }

  List<TaughtLectureModel> processList() {
    List<TaughtLectureModel> list = [];

    if (isExpanded.value) {
      list.addAll(otherLectures.map((lecture) => TaughtLectureModel(
          lecture: lecture,
          isSelected: selectedLecture.value?.id == lecture.id,
          type: TaughtLectureType.regular)));
      list.add(TaughtLectureModel(
          lecture: notMentionedLecture,
          isSelected: selectedLecture.value?.id == notMentionedLecture.id,
          type: TaughtLectureType.not_mentioned));
    } else {
      list.addAll(todayLectures.map((lecture) => TaughtLectureModel(
          lecture: lecture,
          isSelected: selectedLecture.value?.id == lecture.id,
          type: TaughtLectureType.regular)));
      list.add(TaughtLectureModel(
          lecture: otherLecture,
          isSelected: selectedLecture.value?.id == otherLecture.id,
          type: TaughtLectureType.other));
    }

    return list;
  }

  void onTapLecture(LectureModel lecture) {
    selectedLecture.value = lecture;
    if (!isExpanded.value && lecture.id == otherLecture.id) {
      isExpanded.value = true;
    }
  }

  void onTapBack() {
    isExpanded.value = false;
  }
}
