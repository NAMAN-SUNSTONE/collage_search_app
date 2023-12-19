import 'dart:io';
import 'package:admin_hub_app/analytics/events/screens/attendance_report.dart';
import 'package:admin_hub_app/analytics/events/screens/schedule.dart';
import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/modules/beacon/beacon_controller.dart';
import 'package:admin_hub_app/modules/image_uploader/controller.dart';
import 'package:admin_hub_app/modules/login/logout_sheet.dart';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_repo.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:admin_hub_app/widgets/view_image/view_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ScheduleController extends BaseController {
  final ScheduleRepo repo = Get.find<ScheduleRepo>();
  List<EventModel> eventList = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  loadData() async {
    try {
      loading();
      eventList = await repo.getSchedule();
      _filterTodaySchedule();
      success();
    } catch (e) {
      showErrorMessage(e.toString());
      failed();
    }
  }

  Future onRefresh() async {
    await loadData();
  }

  _filterTodaySchedule() {
    eventList.removeWhere((element) => !element.isToday);
  }

  onEventClick(EventModel event) {
    //Get.toNamed(Paths.eventDetail, arguments: event);
  }

  // onTakeAttendance(EventModel event) async {
  //   loading();
  //   if (event.images.isEmpty) {
  //     await _uploadPhoto(event);
  //     _toBeacon(event);
  //   } else {
  //     _toBeacon(event);
  //     // showMyBottomModalSheet(
  //     //   Get.context!,
  //     //   ConfirmSheet(
  //     //     title: 'Taking attendance',
  //     //     message: 'Do you want to take class pic again?',
  //     //     onYes: () async {
  //     //       await _uploadPhoto(event);
  //     //       _toBeacon(event);
  //     //     },
  //     //     onNo: () {
  //     //       _toBeacon(event);
  //     //     },
  //     //   ),
  //     // );
  //   }
  //   success();
  // }

  onEditAttendance(EventModel event) async {
    Get.toNamed(Paths.attendanceReport, arguments: event)
        ?.then((value) => onRefresh());
  }

  onImageClick(String image) {
    // Get.toNamed(Paths.viewImage,
    //     arguments: ViewImageArgument(url: image, title: "Class pic"));
  }

  Future _uploadPhoto(EventModel event) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final List<String> imageList = await repo
            .uploadPhoto(timeTableId: event.id, files: [File(photo.path)]);
        if (imageList.isNotEmpty) {
          loading();
          event.images.addAll(imageList);
          success();
        }
      }
    } catch (e) {
      showErrorMessage(e.toString());
      debugPrint(e.toString());
    }
  }

  // _toBeacon(EventModel event) {
  //   Get.toNamed(Paths.imageUploader,
  //       arguments: ImageUploaderArguments(event,
  //           onNext: () {Get.back();
  //             Get.toNamed(Paths.beacon,
  //                 arguments:
  //                 BeaconArguments(event: event, onRefresh: onRefresh));
  //           }));
  // }
}
