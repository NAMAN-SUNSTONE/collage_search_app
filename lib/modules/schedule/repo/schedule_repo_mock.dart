import 'dart:io';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_repo_base.dart';

class ScheduleRepoMock implements ScheduleRepoBase {
  @override
  Future<List<EventModel>> getSchedule() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> uploadPhoto(
      {required timeTableId, required List<File> files}) {
    throw UnimplementedError();
  }
}
