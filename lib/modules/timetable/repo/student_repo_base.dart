import 'package:admin_hub_app/modules/calendar/data/calendar.dart';

abstract class StudentRepoBase {
  Future<Calendar> fetchCalendarEvents({required DateTime offset, required int limit});
}