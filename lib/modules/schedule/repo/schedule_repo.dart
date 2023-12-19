import 'dart:io';

import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_repo_base.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_service.dart';

class ScheduleRepo implements ScheduleRepoBase {
  @override
  Future<List<EventModel>> getSchedule() async {
    final response = await ScheduleService.getLectures();

    return response
        ?.map((e) => EventModel.fromJson(e))
        ?.toList()
        ?.cast<EventModel>()??[];
  }

  @override
  Future<List<String>> uploadPhoto({required timeTableId, required List<File> files}) async {
    final List<String> response = await ScheduleService.uploadPhoto(
        timeTableId: timeTableId, files: files);

    if (response.isNotEmpty) {
      ScheduleService.
      setImageToEvent(timeTableId.toString(), response);
    }
    return response;
  }
}
