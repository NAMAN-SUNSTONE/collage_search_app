import 'package:admin_hub_app/analytics/events/event_names.dart';
import 'package:admin_hub_app/analytics/events/events.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';

class AttendanceReportPageEvents extends AnalyticEvents {
  submitAttendance(LectureEventListModel event) {
    sendEvent(EventName.attendance_submit, data: {
      'event_id': event.id.toString(),
      'date': event.lectureDate ?? '',
      'start_time': event.lectureStartTime ?? '',
      'end_time': event.lectureEndTime ?? '',
      'subject_name': event.subjectData.courseName ?? ''
    });
  }
}
