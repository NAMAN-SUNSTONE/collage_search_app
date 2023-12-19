import 'dart:io';

import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/deep_links/deep_links.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/attendance_report/model/attendance_model.dart';
import 'package:admin_hub_app/modules/attendance_report/repo/attendance_repo.dart';
import 'package:admin_hub_app/modules/beacon/beacon_controller.dart';
import 'package:admin_hub_app/modules/calendar/data/calendar.dart';
import 'package:admin_hub_app/modules/calendar/ui/widgets/taught_lecture_list.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/image_uploader/controller.dart';
import 'package:admin_hub_app/modules/login/logout_sheet.dart';
import 'package:admin_hub_app/modules/offline/data_sync_view.dart';
import 'package:admin_hub_app/modules/offline/offline_utils.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_repo.dart';
import 'package:admin_hub_app/modules/timetable/data/event_month_model.dart';
import 'package:admin_hub_app/modules/timetable/data/filter_category_model.dart';
import 'package:admin_hub_app/modules/timetable/data/fliter_category_list_model.dart';
import 'package:admin_hub_app/modules/timetable/data/image_row_card.dart';
import 'package:admin_hub_app/modules/timetable/repo/student_repo.dart';
import 'package:admin_hub_app/modules/timetable/repo/student_repo_base.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/constants.dart';
import 'package:admin_hub_app/modules/timetable/scheduler/event_detail/repo/event_repo.dart';
import 'package:admin_hub_app/network/ss_alert.dart';
import 'package:admin_hub_app/remote_config/remote_config.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:admin_hub_app/utils/datetime_extension.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:hub/analytics/events.dart';
// import 'package:hub/app_manager/app_manger.dart';
// import 'package:hub/calendar/data/calendar.dart';
// import 'package:hub/data/filter_general/models/filter_category_model.dart';
// import 'package:hub/data/filter_general/models/fliter_category_list_model.dart';
// import 'package:hub/data/home/model/image_row_card.dart';
// import 'package:hub/data/student/models/target_model.dart';
// import 'package:hub/data/user/models/user_model.dart';
// import 'package:hub/remote_config/remote_config_service.dart';
// import 'package:hub/repos.dart';
// import 'package:hub/routes/page_navigator.dart';
// import 'package:hub/utils/app_lifecycler_observer.dart';
// import 'package:hub/utils/hub_storage.dart';
// import 'package:hub/utils/navigator/navigator.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:visibility_detector/visibility_detector.dart';

// import '../../analytics/event_constants.dart';
import '../../constants/enums.dart';

// import '../../constants/screen_names.dart';
// import '../../data/data.dart';
// import '../../data/student/student.dart';
// import '../base_controller.dart';
// import 'package:hub/utils/extensions.dart';

class TimetableController extends BaseController {
  // late final EventsPublisher publisher = Get.find();

  final selectedDate = DateTime.now().obs;
  final globalKeyCalender = GlobalKey();
  final calendarFormat = CalendarFormat.week.obs;
  DateTime focusedDate = DateTime.now();

  final events = <EventDateModel>[];

  // late final UserRepoLegacy _loginRepo = Get.find();//todo cht

  final StudentRepoBase _studentRepo = Get.find<StudentRepo>();
  final EventRepo _eventRepo = Get.find<EventRepo>();

  final dayFormat = DateFormat('yyyy-MM-dd');
  final _monthFormat = DateFormat('yyyy-MM');

  final admissionYears = <int>[];
  final currentServerDataTime = Rx<String?>(null);

  //Filter List Model
  final Rx<FilterCategoryListModel?> filterCategoryListModel =
      Rx<FilterCategoryListModel?>(null);

  final RxList<FilterCategoryModel> filterCategoryList =
      <FilterCategoryModel>[].obs;

  final RxList<String> selectedFilterListString = <String>[].obs;

  RxList<Widget> calendarWidgets = <Widget>[].obs;
  ScrollDirection currentScrollDirection = ScrollDirection.idle;
  Rx<DateTime> currentSelectedDate = DateTime.now().obs;
  final Key calendarVisibilityKey = Key('calendar');
  double lastCalendarVisibility = 1.0;

  bool isScrolled50 = false;
  bool isScrolled85 = false;
  bool isScrolled30 = false;
  bool isScrolled100 = false;

  String get calendarTitle {
    final today = DateTime.now();
    if (focusedMonth.value.isSameYear(today)) {
      return DateFormat().add_MMMM().format(focusedMonth.value);
    }
    return DateFormat().add_yMMMM().format(focusedMonth.value);
  }

  Rx<Calendar> calendar = Calendar().obs;
  RxList<ImageRowCard> marketingBannerRowCardData = <ImageRowCard>[].obs;
  ItemScrollController positionedScrollController = ItemScrollController();
  ItemPositionsListener positionListener = ItemPositionsListener.create();
  final RxBool isCalendarOpen = false.obs;
  final int pageSize = 30;
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime> currentTopDate = DateTime.now().obs;
  bool timelineLoading = false;
  final ImagePicker _picker = ImagePicker();
  final ScheduleRepo repo = Get.find<ScheduleRepo>();

  final RemoteConfig _remoteConfigService = Get.find();
  final int _fallbackYears = 3;

  @override
  void onInit() async {
    super.onInit();

    // final user = _loginRepo.loginUser;
    // if (user != null) {
    //   //Handling the case for the users whose session has ended but still reach this page
    //   if (user.admissionEndYear < selectedDate.value.year) {
    //     selectedDate.value = DateTime(user.admissionEndYear);
    //   }
    // }
    selectedDate.value = DateTime.now();

    // admissionYears.addAll(_addValidateAdmissionYears(user));
    setInitialFocusDate();

    // AnalyticEvents.screenLoad(screenName: ScreenName.timeTable);

    _processArguments();

    await fetchTimelineForDate(DateTime.now());
    _listenOfflineSync();
    _fetchMarketingBanners();

    positionListener.itemPositions.addListener(_onItemPositionChange);

    updatePosition();

    //todo cht
    // AppLifecycleObserver.instance.updates.listen((state) async {
    //   if (state == AppLifecycleState.resumed) {
    //     if (lastCalendarVisibility == 1) onResume();
    //   }
    // });

    _fetchAndSaveOfflineAttendanceData();
  }

  void _listenOfflineSync() {
    OfflineUtils.syncingStreamController.stream.listen((event) {
      fetchTimelineForDate(DateTime.now());
    });
  }

  Future hardRefresh() async {
    calendar.value.timeline.clear();
    await fetchTimelineForDate(DateTime.now());
    calendar.refresh();
  }

  void onSyncClick() {
    Get.to(DataSyncView());
  }

  void onTapRegisterEvent(LectureEventListModel eventData, bool toRegister) {
    // if (!HubStorage.getInstance().isUserLoggedIn) {
    //   debugPrint('SubscribeToEvent: not logged in, starting auth flow');
    //   HubAppManager.getInstance().goToLogin(
    //       isPopPreviusScreenAll: false,
    //       onSuccessFullyLogined: () {
    //         SHPageNavigator.toTimeTable(
    //             dateString: eventData.lectureDateForDeepLink);
    //       });
    // } else {
    //   AnalyticEvents.registerForCalendarEventClick(eventData, toRegister);
    //   debugPrint('SubscribeToEvent: already logged in, calling API');
    //   _subscribeToEvent(eventData);
    // }
  }

  // Future<void> _subscribeToEvent(LectureEventListModel eventData) async {
  //   Outcome response = await _studentRepo.subscribeToEvent(
  //       id: eventData.id, type: eventData.type ?? '');
  //   if (response is Success<EventSubscription>) {
  //     EventSubscription subscription = response.data;
  //     calendar.value.timeline[eventData.lectureDate]?.firstWhere(
  //         (LectureEventListModel element) =>
  //             (element.id == eventData.id && element.type == eventData.type))
  //       ?..subscription = subscription
  //       ..actions = subscription.actions;
  //     calendar.refresh();
  //   }
  // }

  // List<int> _addValidateAdmissionYears(User? user) {
  //   List<int> admissionYears = <int>[];
  //
  //   if (user != null) {
  //     int admissionStartYear =
  //         int.tryParse(user.admissionYear) ?? focusedDate.year;
  //     int admissionEndYear = user.admissionEndYear;
  //
  //     for (int year = admissionStartYear; year <= admissionEndYear; year++) {
  //       admissionYears.add(year);
  //     }
  //   }
  //
  //   if (admissionYears.isEmpty) {
  //     int currentYear = DateTime.now().year;
  //     for (int i = 0; i < _fallbackYears; i++) {
  //       admissionYears.add(currentYear++);
  //     }
  //   }
  //
  //   return admissionYears;
  // }

  void updatePosition() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        positionedScrollController.jumpTo(
            index: _getDateIndex(dayFormat.format(selectedDate.value)));
        // positionedScrollController.scrollTo(
        //     index: _getDateIndex(dayFormat.format(selectedDate.value)), duration: Duration(milliseconds: 200));
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  void onCalendarVisibilityChange(VisibilityInfo info) {
    debugPrint('Calendar visibility: ${info.visibleFraction}');
    if (info.visibleFraction != lastCalendarVisibility) {
      if (info.visibleFraction == 1) {
        onResume();
      }
    }
    lastCalendarVisibility = info.visibleFraction;
  }

  void onResume() async {
    updatePosition();
    fetchTimelineForDate(DateTime.now());
  }

  _processArguments() {
    var arguments = Get.arguments;
    if (arguments != null && arguments is DateTime) {
      selectedDate.value = arguments;
      focusedDate = arguments;
    }
  }

  _onItemPositionChange() {
    int min = 0;

    Iterable<ItemPosition> positions = positionListener.itemPositions.value;
    if (positions.isNotEmpty) {
      // Determine the first visible item by finding the item with the
      // smallest trailing edge that is greater than 0.  i.e. the first
      // item whose trailing edge in visible in the viewport.
      min = positions
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
          .index;
    }
    List<String> timelineKeys = calendar.value.timeline.keys.toList();
    String dateString = timelineKeys[min];
    DateTime proposedTopDate =
        dateString.toDateTime(dateFormat: dayFormat.pattern!);
    if (!currentTopDate.value.isSameDate(proposedTopDate)) {
      currentTopDate.value = proposedTopDate;

      isTodayButtonActive.value = !proposedTopDate.isSameDate(DateTime.now());
    }
  }

  /// enables/disables the today button
  /// will bt true if current date is not selected
  RxBool isTodayButtonActive = false.obs;

  ///On pressed action of today button
  ///will be redundant if [isTodayButtonActive] is false
  onTodayPressed() {
    if (!isTodayButtonActive.value) return;
    onDateSelected(DateTime.now(), DateTime.now());
  }

  bool onScrollNotification(ScrollEndNotification notification) {
    ScrollMetrics metrics = notification.metrics;
    double progress = metrics.pixels / metrics.maxScrollExtent;

    // _trackScrollForAnalytics(progress);

    if (metrics.atEdge && !timelineLoading) {
      /*if (progress == 0) {
        fetchTimelineForDate(calendar.value.timeline.keys.first.toDateTime(dateFormat: dayFormat.pattern!), backward: true, forward: false);
      } else*/
      if (progress == 1) {
        fetchTimelineForDate(
            calendar.value.timeline.keys.last
                .toDateTime(dateFormat: dayFormat.pattern!)
                .add(Duration(days: 1)),
            backward: false,
            forward: true);
      }
    }

    return true;
  }

  @override
  void onClose() async {
    super.onClose();

    //Publish Event
    // publisher.publishEvent(
    //   eventName: EventConst.screenUnLoad,
    //   eventType: AnalyticsEventTypes.withScreenName,
    //   screenName: ScreenName.timeTable,
    // );
  }

  void setInitialFocusDate() {
    DateTime currentTime = DateTime.now();
    DateTime programEndYear = DateTime(currentTime.year + 3, 12, 31);
    if (programEndYear.difference(currentTime).isNegative) {
      focusedDate = programEndYear;
    } else {
      focusedDate = currentTime;
    }
  }

  Future<void> fetchTimelineForDate(DateTime date,
      {bool forward = true,
      bool backward = true,
      bool fetchEvents = true,
      Function? onComplete = null}) async {
    if (calendar.value.timeline.isEmpty) {
      loading();
    }
    timelineLoading = true;

    if (fetchEvents) {
      // _fetchEvents();//todo cht
    }
    try {
      DateTime startDate;

      if (forward && backward) {
        startDate = date.subtract(Duration(days: (pageSize ~/ 2)));
      } else if (forward) {
        startDate = date;
      } else {
        startDate = date.subtract(Duration(days: pageSize));
      }

      try {
        final Calendar calendar = await _studentRepo.fetchCalendarEvents(
            offset: startDate, limit: pageSize);
        _refreshTimeline(calendar, forward: forward, backward: backward);
      } catch (e) {
        debugPrint(e.toString());
        failed();
        if (calendar.value.timeline.isEmpty) {
          updateStatus(Status.error);
        }
      }
    } on Exception {
      showErrorMessage('Error while fetching Timetable');
    }

    timelineLoading = false;
    onComplete?.call();
  }

  int calls = 0; // for debugging purpose only
  void _refreshTimeline(Calendar newData,
      {bool forward = true, bool backward = true}) {
    currentServerDataTime.value = newData.serverTime;

    if (calendar.value.timeline.isEmpty) {
      debugPrint(
          'Calendar: [call $calls] calendar was empty, setting calendar value with new data');
      success();
      calendar.value = newData;
      calendar.refresh();
      calls++;
      return;
    }

    List<String> timelineKeys = calendar.value.timeline.keys.toList();
    DateTime timelineStart =
        timelineKeys.first.toDateTime(dateFormat: dayFormat.pattern!);
    DateTime timelineEnd =
        timelineKeys.last.toDateTime(dateFormat: dayFormat.pattern!);

    List<String> newDataKeys = newData.timeline.keys.toList();
    DateTime newDataStart =
        newDataKeys.first.toDateTime(dateFormat: dayFormat.pattern!);
    DateTime newDataEnd =
        newDataKeys.last.toDateTime(dateFormat: dayFormat.pattern!);

    // case: new data is of after existing timeline
    if (newDataStart.isAfter(timelineEnd)) {
      debugPrint('Calendar: [call $calls] new data is of after old data');

      if (newDataStart.difference(timelineEnd) > Duration(days: 1)) {
        // flush old list and treat new data as source
        debugPrint(
            'Calendar: [call $calls] there is a gap between new and old data, replacing calendar with new data');
        calendar.value = newData;
      } else {
        // append at end
        debugPrint('Calendar: [call $calls] appending calendar with new data');
        calendar.value.serverTime = newData.serverTime;
        calendar.value.timeline.addAll(newData.timeline);
      }

      // case: new data is of before existing timeline
    } else if (newDataEnd.isBefore(timelineStart)) {
      debugPrint('Calendar: [call $calls] new data is of before old data');

      if (newDataEnd.difference(timelineStart) > Duration(days: 1)) {
        // flush old list and treat new data as source
        debugPrint(
            'Calendar: [call $calls] there is a gap between new and old data, replacing calendar with new data');
        calendar.value = newData;
      } else {
        // append at beginning: assuming SplayTreeMap is always sorted
        debugPrint('Calendar: [call $calls] prepending calendar with new data');
        calendar.value.serverTime = newData.serverTime;
        newData.timeline.addAll(calendar.value.timeline);
        calendar.value.timeline.clear();
        calendar.value.timeline.addAll(newData.timeline);
      }
    } else if ((newDataStart.isAfter(timelineStart) ||
            newDataStart.isSameDate(timelineStart)) &&
        (newDataEnd.isBefore(timelineEnd) ||
            newDataEnd.isSameDate(timelineEnd))) {
      debugPrint(
          'Calendar: [call $calls] updating data, new data range is inclusive of existing data');
      calendar.value.serverTime = newData.serverTime;
      calendar.value.updateDates(newData.timeline);
    } else {
      debugPrint(
          'Calendar: [call $calls] simply, replacing calendar with new data');
      calendar.value = newData;
    }

    // int oldPosition = _getDateIndex(dayFormat.format(forward ? timelineEnd : timelineStart));
    // int newPosition;
    // if (forward) {
    //   newPosition = _getDateIndex(_firstNonEmpty(calendar.value.timeline) ?? dayFormat.format(timelineEnd));
    // } else {
    //   newPosition = _getDateIndex(_lastNonEmpty(calendar.value.timeline) ?? dayFormat.format(timelineStart));
    // }

    debugPrint('Calendar: [call $calls] refreshing ui');
    calendar.refresh();

    calls++;
  }

  void _fetchMarketingBanners() {
    // marketingBannerRowCardData
    //     .addAll(_remoteConfigService.calendarMarketingBanners);
    // marketingBannerRowCardData.refresh();
  }

  void onRetry() async {
    await fetchTimelineForDate(DateTime.now());
  }

  // Future<void> _fetchFilterList() async {
  //   startLoading();
  //
  //   try {
  //     final data = await _studentRepo.fetchScheduleFilters();
  //
  //     if (data is Success) {
  //       final FilterCategoryListModel filterData = (data as Success).data;
  //       filterCategoryListModel.value = filterData;
  //       filterCategoryList.value =
  //           filterCategoryListModel.value!.filterCategory;
  //     } else {}
  //   } on Exception {
  //     showErrorMessage('Error while fetching Timetable');
  //   }
  //   success();
  // }

  int computeMonthIndex(DateTime day) {
    int month = day.month - 1;
    int year = day.year;
    if (admissionYears.contains(year)) {
      final int index = admissionYears.indexOf(year);
      month += index * 12;
    }
    return month;
  }

  void onDateSelected(DateTime selectedDay, DateTime focusedDay) {
    //changes the page for the month calendar
    final int _page = computeMonthIndex(selectedDay);
    if (_calendarCardController != null &&
        _calendarCardController!.page != _page)
      _calendarCardController!.animateToPage(_page,
          duration: Duration(seconds: 1), curve: Curves.easeIn);

    selectedDate.value = selectedDay;
    // AnalyticEvents.dateSelect(selectedDay.toString());
    if (calendar.value.timeline.containsKey(dayFormat.format(selectedDay))) {
      navigateToDate(selectedDay);
      return;
    }
    fetchTimelineForDate(selectedDay,
        onComplete: () => navigateToDate(selectedDay));
  }

  void navigateToDate(DateTime day) {
    if (!positionedScrollController.isAttached) return;
    positionedScrollController.scrollTo(
        index: _getDateIndex(dayFormat.format(day)),
        duration: Duration(milliseconds: 500));
  }

  int _getDateIndex(String dateString) {
    List<String> keys = calendar.value.timeline.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      if (keys[i] == dateString) {
        return i;
      }
    }

    return 0;
  }

  List<EventDateModel> eventCallback(DateTime day) {
    final formattedDate = dayFormat.format(day);
    return events
        .where((event) =>
            dayFormat.format(DateTime.fromMillisecondsSinceEpoch(event.date)) ==
            formattedDate)
        .toList();
  }

  void onPageChanged(DateTime focusedDay) async {
    focusedMonth.value = focusedDay;
    if (focusedDay.month != focusedDate.month) {
      focusedDate = focusedDay;
      // await _fetchEvents();//todo cht
    } else {
      focusedDate = focusedDay;
    }
    calendar.refresh();
  }

  PageController? _calendarCardController;

  onCardCalendarCreated(PageController pageController) {
    this._calendarCardController = pageController;
  }

  void _createFileterList() {
    List<String> selectedFiletrList = [];
    for (var i = 0; i < filterCategoryList.length; i++) {
      for (var j = 0; j < filterCategoryList[i].singleFilterModel.length; j++) {
        if (filterCategoryList[i].singleFilterModel[j].isSelected) {
          selectedFiletrList
              .add(filterCategoryList[i].singleFilterModel[j].identifier);
        }
      }
    }

    selectedFilterListString.value = selectedFiletrList;
  }

  void onChangeFilterValue(int categoryIndex, int filterIndex, bool? newVal) {
    if (newVal != null && newVal) {
      filterCategoryList[categoryIndex]
          .singleFilterModel[filterIndex]
          .isSelected = newVal;
      _checkAllCategoryItemsSlection(categoryIndex);
      _createFileterList();
    } else {
      filterCategoryList[categoryIndex]
          .singleFilterModel[filterIndex]
          .isSelected = newVal ?? false;
      _checkAllCategoryItemsSlection(categoryIndex);
      _createFileterList();
    }

    filterCategoryList.refresh();
  }

  //Method To Check That Any Category  all Filters are selcted Or Not
  void _checkAllCategoryItemsSlection(int categoryIndex) {
    bool isAllSelected = true;

    for (var i = 0;
        i < filterCategoryList[categoryIndex].singleFilterModel.length;
        i++) {
      if (!filterCategoryList[categoryIndex].singleFilterModel[i].isSelected) {
        isAllSelected = false;
      }
    }

    if (isAllSelected) {
      filterCategoryList[categoryIndex].isSelcted = true;
    } else {
      filterCategoryList[categoryIndex].isSelcted = false;
    }

    filterCategoryList.refresh();
  }

  //Method To Check to automatically add/Remove all the filter Items dependfing upon category Selection/Unselection
  void _onCategorySelctedUnselected(int categoryIndex) {
    for (var i = 0;
        i < filterCategoryList[categoryIndex].singleFilterModel.length;
        i++) {
      filterCategoryList[categoryIndex].singleFilterModel[i].isSelected =
          filterCategoryList[categoryIndex].isSelcted;
    }

    filterCategoryList.refresh();
  }

  void onChangeCategoryValue(int categoryIndex, bool? newVal) {
    //If Any Whole Category IsSelected
    if (newVal != null && newVal) {
      filterCategoryList[categoryIndex].isSelcted = newVal;

      _onCategorySelctedUnselected(categoryIndex);

      _createFileterList();
    } else {
      filterCategoryList[categoryIndex].isSelcted = newVal ?? false;

      _onCategorySelctedUnselected(categoryIndex);

      _createFileterList();
    }

    filterCategoryList.refresh();
  }

  // Future<void> _fetchEvents() async {
  //   try {
  //     final evntData = await _studentRepo.fetchMonthTimeTable(
  //         date: _monthFormat.format(focusedDate));
  //     if (evntData is Success) {
  //       final EventMonth eventMonth = (evntData as Success).data;
  //       events
  //         ..clear()
  //         ..addAll(eventMonth.dates);
  //     } else {}
  //   } on Exception {
  //     showErrorMessage('Error while fetching Events');
  //   }
  // }

  // void _trackScrollForAnalytics(double scrollOffset) {
  //   double scrollPercentage = scrollOffset * 100;
  //
  //   if (scrollPercentage > 30 && scrollPercentage < 50 && !isScrolled30) {
  //     publisher.publishEvent(
  //       eventName: EventConst.scroll30,
  //       eventType: AnalyticsEventTypes.withScreenName,
  //       screenName: ScreenName.timeTable,
  //     );
  //     isScrolled30 = true;
  //   } else if (scrollPercentage > 50 &&
  //       scrollPercentage < 85 &&
  //       !isScrolled50) {
  //     publisher.publishEvent(
  //       eventName: EventConst.scroll50,
  //       eventType: AnalyticsEventTypes.withScreenName,
  //       screenName: ScreenName.timeTable,
  //     );
  //
  //     isScrolled50 = true;
  //   } else if (scrollPercentage > 85 &&
  //       !isScrolled85 &&
  //       scrollPercentage < 95) {
  //     publisher.publishEvent(
  //       eventName: EventConst.scroll85,
  //       eventType: AnalyticsEventTypes.withScreenName,
  //       screenName: ScreenName.timeTable,
  //     );
  //
  //     isScrolled85 = true;
  //   } else if (scrollPercentage > 95 && !isScrolled100) {
  //     publisher.publishEvent(
  //       eventName: EventConst.scroll100,
  //       eventType: AnalyticsEventTypes.withScreenName,
  //       screenName: ScreenName.timeTable,
  //     );
  //
  //     isScrolled100 = true;
  //   }
  // }

  // void onCalendarSwitch() {
  //   isCalendarOpen.value = !isCalendarOpen.value;
  // }

  void onTapMarkLecture(LectureEventListModel event) {
    BuildContext? context = Get.context;
    if (context == null) return;

    showMyBottomModalSheet(
        context,
        TaughtLectureList(
            event: event,
            todayLectures: event.metaData.todayLectures,
            otherLectures: event.metaData.otherLectures,
            ctaText: 'Take Attendance',
        onTapCta: (lecture) {
              Navigator.pop(context);
          markLecture(event, lecture);
        }),
    color: HubColor.white);
  }

  void onTapMarkLectureAndJoin(LectureEventListModel event) {
    BuildContext? context = Get.context;
    if (context == null) return;

    showMyBottomModalSheet(
        context,
        TaughtLectureList(
            event: event,
            todayLectures: event.metaData.todayLectures,
            otherLectures: event.metaData.otherLectures,
            ctaText: 'Confirm and Join',
            onTapCta: (lecture) {
              Navigator.pop(context);
              markLecture(event, lecture);
            }),
        color: HubColor.white);
  }

  Future<void> markLecture(LectureEventListModel event, LectureModel lecture) async {
    loading();
    try {
      SSAlert? alert = await _eventRepo.markLecture(eventId: event.id, type: event.classType, lectureId: lecture.id);
      if (alert != null) {
        if (alert.actions.isNotEmpty) {
          switch (alert.actions.first.deeplink) {
            case AlertDeeplinkIdentifiers.hubTakeAttendance:
              onTapTakeAttendance(event);
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

  void onTapTakeAttendance(LectureEventListModel event) async {
    if (event.classPictures.isEmpty) {
      await _uploadPhoto(event);
      _toBeacon(event);
    } else {
      _toBeacon(event);
      showMyBottomModalSheet(
        Get.context!,
        ConfirmSheet(
          title: 'Taking attendance',
          message: 'Do you want to take class picture again?',
          onYes: () async {
            await _uploadPhoto(event);
            _toBeacon(event);
          },
          onNo: () {
            _toBeacon(event);
          },
        ),
      );
    }
  }

  onTapEditAttendance(LectureEventListModel event) async {
    Get.toNamed(Paths.attendanceReport, arguments: event);
  }

  // onImageClick(String image) {
  //   Get.toNamed(Paths.viewImage,
  //       arguments: ViewImageArgument(url: image, title: "Class pic"));
  // }

  Future _uploadPhoto(LectureEventListModel event) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        if (await ConnectivityManager.isOnline()) {
          final List<String> imageList = await repo
              .uploadPhoto(timeTableId: event.id, files: [File(photo.path)]);
          if (imageList.isNotEmpty) {
            loading();
            event.classPictures.addAll(imageList);
            success();
          }
        } else {
          await DatabaseHelper.insertAttendanceImage(eventId: event.id, path: photo.path);
        }
      }
    } catch (e) {
      showErrorMessage(e.toString());
      debugPrint(e.toString());
    }
  }

  _toBeacon(LectureEventListModel event) async {
    Get.toNamed(Paths.imageUploader,
        arguments: ImageUploaderArguments(event, onNext: () async {
          Get.back();
          if (await ConnectivityManager.isOnline()) {
            Get.toNamed(Paths.beacon,
                arguments: BeaconArguments(
                    event: event,
                    onRefresh: () {}));
          } else {
            Get.toNamed(Paths.attendanceReport, arguments: event);
          }
        }));
  }

  Future<void> _fetchAndSaveOfflineAttendanceData() async {
    List<int> eventIds = await DatabaseHelper.fetchAttendanceMissingEvents();

    if (eventIds.isNotEmpty) {
      AttendanceRepo attendanceRepo = Get.find<AttendanceRepo>();

      eventIds.forEach((id) async {

        AttendanceModel attendance = await attendanceRepo.getAttendance(timeTableId: id.toString());
        await DatabaseHelper.insertAttendance(attendance);
      });
    }
  }
}
