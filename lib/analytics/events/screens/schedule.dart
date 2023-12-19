import 'package:admin_hub_app/analytics/events/event_names.dart';
import 'package:admin_hub_app/analytics/events/events.dart';
import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/utils/hub_storage.dart';

class SchedulePageEvents extends AnalyticEvents {
  takeAttendance(EventModel event) {
    sendEvent(EventName.take_attendance, data: {
      'event_id': event.id.toString(),
      'date': event.lectureDate ?? '',
      'start_time': event.lectureStartTime ?? '',
      'end_time': event.lectureEndTime ?? '',
      'subject_name': event.subjectName ?? ''
    });
  }

  void eventCtaClick(LectureEventListModel event, String deeplink) {
    sendEvent(EventName.eventCtaClick, data: {
      'event_name': event.displayTitle,
      'event_date': event.lectureDate,
      'subject_name': event.subjectData.courseName,
      'deeplink': deeplink
    });
  }

  void markLecture(LectureEventListModel event, LectureModel mapped, LectureModel taught) {
    sendEvent(EventName.markLecture, data: {
      'event_name': event.displayTitle,
      'event_date': event.lectureDate,
      'subject_name': event.subjectData.courseName,
      'lecture_mapped': mapped.title,
      'lecture_taught': taught.title
    });
  }

  void openContent(LectureEventListModel event, LectureModel lecture) {
    sendEvent(EventName.openContent, data: {
      'subject_name': event.subjectData.courseName,
      'lecture_id': lecture.id,
      'lecture_name': lecture.title,
      'content_id': event.id
    });
  }

  void openLectureHandbook(LectureEventListModel event, LectureModel lecture) {
    sendEvent(EventName.openLectureHandbook, data: {
      'user_id': HubStorage.getInstance().userId,
      'program_id': event.subjectData.programId,
      'term': event.subjectData.term,
      'subject_id': event.subjectData.subjectId,
      'subject_name': event.subjectData.courseName,
      'lecture_name': lecture.title,
      'lecture_id': lecture.id
    });
  }
}
