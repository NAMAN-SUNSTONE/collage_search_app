import 'package:admin_hub_app/modules/calendar/data/calendar.dart';
import 'package:admin_hub_app/modules/timetable/repo/student_repo.dart';

class StudentRepoMock implements StudentRepo {
  @override
  Future<Calendar> fetchCalendarEvents({required DateTime offset, required int limit}) {
    // TODO: implement fetchCalendarEvents
    throw UnimplementedError();
  }

}