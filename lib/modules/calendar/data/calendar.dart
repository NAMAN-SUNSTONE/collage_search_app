// import 'package:hub/data/student/models/lecture_model.dart';

import 'package:admin_hub_app/modules/content_view/lecture_model.dart';

class Calendar {

  String? serverTime;
  Map<String, List<LectureEventListModel>> timeline = {};

  void updateDates(Map<String, List<LectureEventListModel>> timelineChunk) {
    timelineChunk.forEach((key, value) {
      timeline[key] = value;
    });
  }

}