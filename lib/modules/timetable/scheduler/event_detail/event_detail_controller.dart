import 'dart:io';

import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/deep_links/deep_links.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/beacon/beacon_controller.dart';
import 'package:admin_hub_app/modules/calendar/ui/widgets/taught_lecture_list.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/image_uploader/controller.dart';
import 'package:admin_hub_app/modules/login/logout_sheet.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_repo.dart';
import 'package:admin_hub_app/modules/timetable/repo/student_repo.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/event_detail/repo/event_repo.dart';
import 'package:admin_hub_app/modules/timetable/widgets/single_lecture_widget.dart';
import 'package:admin_hub_app/network/ss_action_exception.dart';
import 'package:admin_hub_app/network/ss_alert.dart';
import 'package:admin_hub_app/remote_config/remote_config.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:admin_hub_app/utils/hub_storage.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/app_manager/app_manger.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/data/outcome.dart';
// import 'package:hub/data/student/models/lecture_model.dart';
// import 'package:hub/remote_config/remote_config_service.dart';
// import 'package:hub/data/student/repos/student_repo_new.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/routes/page_navigator.dart';
// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/ui/timetable/scheduler/notes/view/notes_controller.dart';
// import 'package:hub/ui/timetable/widgets/single_lecture_widget.dart';
// import 'package:hub/ui/timetable/scheduler/event_detail/repo/event_repo.dart';
// import 'package:hub/utils/hub_storage.dart';
import 'package:intl/intl.dart';
// import 'package:hub/network/ss_action_exception.dart';

class EventDetailController extends BaseController {
  //kill switch for attendance
  bool isBeaconAttendanceActive = true;
  final Rx<LectureDataToPass?> lectureDataGot = Rx<LectureDataToPass?>(null);
  final Rx<LectureEventListModel?> lectureData =
  Rx<LectureEventListModel?>(null);
  Rx<NotesModel?> note = Rx<NotesModel?>(null);
  final Rx<DateTime> serverDatTime = DateTime
      .now()
      .obs;
  String? roomsNames;
  Rx<RoomModel?> onlineRoom = Rx<RoomModel?>(null);
  String subject = '';
  String lectureStartTime = '';
  final eventDetailStatus = Status.init.obs;
  RxBool showNewTag = false.obs;

  final _formatServerTime = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
  final ImagePicker _picker = ImagePicker();

  static const String _online = 'online';
  static const String _roomConst = 'room';
  static const String _examEventTypeConst = "exam";
  final EventRepo _eventRepo = Get.find<EventRepo>();

  // final StudentRepo _studentRepo = Get.find();
  final ScheduleRepo repo = Get.find<ScheduleRepo>();

  String? errorMessage;

  @override
  Future<void> onInit() async {
    //Get Arguments From Previous Screen

    initNewTag();
    await loadData(showLoader: true);
    super.onInit();
  }

  Future<void> loadData({bool showLoader = true}) async {
    try {
      if (Get.parameters.isNotEmpty)
        lectureDataGot.value = LectureDataToPass.fromJson(Get.parameters);
    } catch (e) {
      showErrorMessage('No Data Model Passed to this screen.');
    }

    if (lectureDataGot.value != null) {
      int? eventId = lectureDataGot.value!.eventId;
      String? type = lectureDataGot.value!.type;
      eventDetailStatus.value = Status.loading;

      try {
        await fetchEventDetails(eventId, type, showLoader: showLoader);
        eventDetailStatus.value = Status.success;
      } catch (e) {
        eventDetailStatus.value = Status.error;
        errorMessage = (e as SSActionException).errorMsg;
      }
      isBeaconAttendanceActive =
          !(lectureData.value?.isStudentPresent ?? false) &&
              lectureData.value?.classType != '1';
    } else {
      return;
    }
  }

  Future<void> onRefresh() async {
    await loadData(showLoader: false);
  }

  // todo centralise this function
  void onTapRegisterEvent(bool toRegister) {
    // AnalyticEvents.registerForCalendarEventClick(
    //     lectureData.value!, toRegister);

    // if (!HubStorage.getInstance().isUserLoggedIn) {
    //   debugPrint('SubscribeToEvent: not logged in, starting auth flow');
    //   HubAppManager.getInstance().goToLogin(
    //       isPopPreviusScreenAll: false,
    //       onSuccessFullyLogined: () {
    //         SHPageNavigator.toTimeTable(
    //             dateString: lectureData.value!.lectureDateForDeepLink);
    //       });
    // } else {
    //   debugPrint('SubscribeToEvent: already logged in, calling API');
    //   _subscribeToEvent();
    // }
  }

  // Future<void> _subscribeToEvent() async {
  //   Outcome response =
  //       await _studentRepo.subscribeToEvent(id: lectureData.value?.id??0,type: lectureData.value?.type??'');
  //   if (response is Success<EventSubscription>) {
  //     EventSubscription subscription = response.data;
  //     lectureData.value!.subscription = subscription;
  //     lectureData.value!.actions = subscription.actions;
  //     lectureData.refresh();
  //   }
  // }

  initNewTag() {
    //todo: check for if note already exists
    // showNewTag.value = HubStorage.getInstance().showNoteNewTag;
  }

  // onNoteClick() {
  //   if (lectureData.value == null) return;
  //   Get.toNamed(Paths.notesView,
  //       arguments: NotesArgument(
  //           title: subject,
  //           eventId: lectureData.value!.id,
  //           note: note.value,
  //           lectureType: lectureData.value!.type,
  //           onNoteUpdate: (updatedNote) {
  //             try {
  //               note.value = updatedNote;
  //               updatedNote == null
  //                   ? lectureData.value!.notes = []
  //                   : lectureData.value!.notes = [updatedNote];
  //             } catch (e) {
  //               debugPrint(e.toString());
  //             }
  //           },
  //           lectureStartTime: lectureStartTime));
  //   showNewTag.value = false;
  //   HubStorage.getInstance().showNoteNewTag = false;
  // }

  void onPlayVideo(ClassRecordingModel recordingData) {
    // AnalyticEvents.noteViewRecordingEvent(subject, lectureStartTime);
    Map<String, dynamic> routeData = {
      'videoUrl': recordingData.url,
      'videoName': ''
    };
    // Get.toNamed(Paths.videoPlayer, arguments: routeData); //todo cht
  }

  void setRoomDetails() {
    for (int roomCount = 0;
    roomCount < (lectureData.value?.rooms.length ?? 0);
    roomCount++) {
      RoomModel roomData = lectureData.value!.rooms[roomCount];

      if (roomData.type?.toLowerCase() == _online) {
        onlineRoom.value = roomData;
      } else if (roomData.type?.toLowerCase() == _roomConst) {
        if (roomCount == 0) {
          roomsNames = roomData.roomNumber;
        } else {
          roomsNames = '$roomsNames, ${roomData.roomNumber}';
        }
      }
    }
  }

  String? get professorNames {
    String? names;
    final professors = lectureData.value?.professors;
    for (int professorCount = 0;
    professorCount < (professors?.length ?? 0);
    professorCount++) {
      final name = professors![professorCount].name;
      if (professorCount == 0) {
        names = name;
      } else {
        names = '$names, $name';
      }
    }

    return names;
  }

  Future<void> fetchEventDetails(int eventId, String? type,
      {bool showLoader = true}) async {
    if (showLoader) eventDetailStatus.value = Status.loading;

    try {
      lectureData.value =
      await _eventRepo.getEventDetails(eventId: eventId, type: type);

      if (lectureData.value!.notes != null &&
          lectureData.value!.notes!.isNotEmpty) {
        note.value = lectureData.value!.notes?.first;
      }
      if (lectureDataGot.value!.currentServerDateTime != null &&
          lectureDataGot.value!.currentServerDateTime!.isNotEmpty) {
        serverDatTime.value = _formatServerTime.parse(
            lectureDataGot.value!.currentServerDateTime!, true);
      }
      setRoomDetails();
      subject = lectureData.value!.subjectData.courseName.isNotEmpty
          ? lectureData.value!.subjectData.courseName
          : lectureData.value!.metaData.topic;

      lectureStartTime =
      "${lectureData.value!.lectureDate} at ${lectureData.value!
          .lectureStartTime}";

      eventDetailStatus.value = Status.success;
    } catch (e) {
      eventDetailStatus.value = Status.error;
      errorMessage = (e as SSActionException).errorMsg;
    }
  }

  bool get shouldShowMarkAttendance =>
      isBeaconAttendanceActive &&
          eventDetailStatus.value == Status.success &&
          lectureData.value!.eventType != _examEventTypeConst;


  void onTapMarkLecture() {
    BuildContext? context = Get.context;
    if (context == null) return;

    showMyBottomModalSheet(
        context,
        TaughtLectureList(
            event: lectureData.value!,
            todayLectures: lectureData.value!.metaData.todayLectures,
            otherLectures: lectureData.value!.metaData.otherLectures,
            ctaText: 'Take Attendance',
            onTapCta: (lecture) {
              Navigator.pop(context);
              markLecture(lecture);
            }),
        color: HubColor.white,
        onClose: onRefresh);
  }

  void onTapMarkLectureAndJoin() {
    BuildContext? context = Get.context;
    if (context == null) return;

    showMyBottomModalSheet(
        context,
        TaughtLectureList(
            event: lectureData.value!,
            todayLectures: lectureData.value!.metaData.todayLectures,
            otherLectures: lectureData.value!.metaData.otherLectures,
            ctaText: 'Confirm and Join',
            onTapCta: (lecture) {
              Navigator.pop(context);
              markLecture(lecture);
            }),
        color: HubColor.white,
        onClose: onRefresh);
  }

  Future<void> markLecture(LectureModel lecture) async {
    loading();
    try {
      SSAlert? alert = await _eventRepo.markLecture(
          eventId: lectureData.value!.id,
          type: lectureData.value!.classType,
          lectureId: lecture.id);
      if (alert != null) {
        if (alert.actions.isNotEmpty) {
          switch (alert.actions.first.deeplink) {
            case AlertDeeplinkIdentifiers.hubTakeAttendance:
              onTapTakeAttendance();
              break;
            default:
              DeepLinks.getInstance().register(alert.actions.first.deeplink);
              break;
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    success();
  }

  void onTapTakeAttendance() async {
    if (lectureData.value!.classPictures.isEmpty) {
      await _uploadPhoto();
      _toBeacon();
    } else {
      _toBeacon();
      showMyBottomModalSheet(
        Get.context!,
        ConfirmSheet(
          title: 'Taking attendance',
          message: 'Do you want to take class picture again?',
          onYes: () async {
            await _uploadPhoto();
            _toBeacon();
          },
          onNo: () {
            _toBeacon();
          },
        ),
      );
    }
  }

  onTapEditAttendance() async {
    Get.toNamed(Paths.attendanceReport, arguments: lectureData.value!)
        ?.then((value) => onRefresh());
  }

  Future _uploadPhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        if (await ConnectivityManager.isOnline()) {
          final List<String> imageList = await repo
              .uploadPhoto(timeTableId: lectureData.value!.id, files: [File(photo.path)]);
          if (imageList.isNotEmpty) {
            loading();
            lectureData.value!.classPictures.addAll(imageList);
            success();
          }
        } else {
          await DatabaseHelper.insertAttendanceImage(eventId: lectureData.value!.id, path: photo.path);
        }
      }
    } catch (e) {
      showErrorMessage(e.toString());
      debugPrint(e.toString());
    }
  }

  _toBeacon() async {
    Get.toNamed(Paths.imageUploader,
        arguments: ImageUploaderArguments(lectureData.value!, onNext: () async {
          Get.back();
          if (await ConnectivityManager.isOnline()) {
            Get.toNamed(Paths.beacon,
                arguments: BeaconArguments(
                    event: lectureData.value!,
                    onRefresh: () {}));
          } else {
            Get.toNamed(Paths.attendanceReport, arguments: lectureData.value!);
          }
        }));
  }
}
