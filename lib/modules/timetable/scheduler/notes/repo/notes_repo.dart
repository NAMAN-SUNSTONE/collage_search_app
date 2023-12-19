import 'package:hub/data/student/models/lecture_model.dart';
import 'package:hub/sunstone_base/data/ss_file.dart';
import 'package:hub/ui/timetable/scheduler/notes/repo/notes_service.dart';

abstract class NotesRepo {
  Future<NotesModel> createUpdateNotes(
      {required int eventId,
      String title,
      String body,
      required String lectureType,
      int? noteId,
      SSFile? file});

  Future deleteNote(String noteId);
  Future deleteAttachment(String attachmentId);
}

class NotesRepoImpl implements NotesRepo {
  @override
  Future<NotesModel> createUpdateNotes(
      {required int eventId,
      String? title,
      String? body,
      required String lectureType,
      int? noteId,
      SSFile? file}) async {
    Map<String, dynamic> params = {
      "time_table_id": eventId,
      'type': lectureType
    };

    if (body != null && body != "") params['description'] = body;
    if (title != null) params['title'] = title;
    if (noteId != null) params['id'] = noteId;

    final response = await NotesAPI.createUpdateNotes(params, file: file);
    return NotesModel.fromJson(response);
  }

  @override
  Future deleteNote(String noteId) async {
    return await NotesAPI.deleteNote(noteId);
  }

  @override
  Future deleteAttachment(String attachmentId) async {
    return await NotesAPI.deleteAttachment(attachmentId);
  }
}
