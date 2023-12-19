import 'dart:io';

import 'package:admin_hub_app/modules/schedule/model/event_model.dart';

abstract class ScheduleRepoBase {
  Future<List<EventModel>> getSchedule();
  Future<List<String>> uploadPhoto(
      {required timeTableId, required List<File> files});
}
