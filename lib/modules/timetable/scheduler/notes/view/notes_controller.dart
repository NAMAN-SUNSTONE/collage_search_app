import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hub/analytics/events.dart';
import 'package:hub/constants/app_constants.dart';
import 'package:hub/constants/constants.dart';
import 'package:hub/data/student/models/lecture_model.dart';
import 'package:hub/sunstone_base/data/ss_file.dart';
import 'package:hub/theme/colors.dart';
import 'package:hub/ui/timetable/scheduler/notes/repo/notes_repo.dart';
import 'package:hub/utils/throttle_debounce.dart';
import 'package:hub/widgets/reusables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:hub/utils/datetime_extension.dart';

class NotesArgument {
  final int eventId;
  final NotesModel? note;
  final Function onNoteUpdate;
  final String title;
  final String lectureStartTime;
  final String? lectureType;
  NotesArgument({
    required this.title,
    required this.eventId,
    required this.note,
    required this.onNoteUpdate,
    this.lectureType = AppConstant.calenderTimeTableCard,
    required this.lectureStartTime,
  });
}

///note's title and description will be saved on 3 cases:
/// 1. On page pop
/// 2. On making any changes
/// 3. On app Inactive state
///Attachments is independent of the above and will be saved instantly on any change in attachments

class NotesController extends SuperController {
  NotesModel? _note;
  late final int eventId;
  late Function onNoteUpdateCallBack;

  final NotesRepo _noteRepo = NotesRepoImpl();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxList<NotesAttachmentModel> attachments = RxList<NotesAttachmentModel>();
  //if false, then button will hide
  RxBool showAttachmentButton = true.obs;
  //turns down to true, if there's any change in title and description of the notes
  // attachments have no changes here..
  final bool anyChanges = false;
  // debouncing instances
  final Debounce _scrollDebounce = Debounce();
  final Debounce _notesUpdateDebounce = Debounce();
  String subject = '';
  String lectureType = '';
  String lectureStartTime = '';
  RxBool savedOnce = false.obs;
  RxString lastSavedOn = RxString('');
  @override
  onInit() {
    super.onInit();
    initFields();
    scrollController.addListener(_scrollListener);
    titleController.addListener(_onTitleChange);
    bodyController.addListener(_onBodyChange);
  }

  @override
  onClose() {
    super.onClose();
    _dispose();
  }

  @override
  void onDetached() {}

  @override
  void onInactive() => _saveNotes(forceUpdate: true);

  @override
  void onPaused() {}

  @override
  void onResumed() {}

  initFields() {
    if (Get.arguments is! NotesArgument) {
      throw Exception('Please provide notes argument only');
    }
    final NotesArgument notesArgument = Get.arguments;
    eventId = notesArgument.eventId;
    onNoteUpdateCallBack = notesArgument.onNoteUpdate;
    subject = notesArgument.title;
    lectureStartTime = notesArgument.lectureStartTime;
    lectureType =
        notesArgument.lectureType ?? AppConstant.calenderTimeTableCard;
    titleController.text = subject;

    if (notesArgument.note != null) {
      _note = notesArgument.note;
      titleController.text = _note!.title;
      bodyController.text = _note!.description;

      updateLastSaved(notesArgument.note!.modified);
      attachments.value = notesArgument.note!.attachments;
    }
    if (_note != null) savedOnce.value = true;
  }

  updateLastSaved(String time) {
    try {
      if (!savedOnce.value) savedOnce.value = true;
      DateTime _dateTimeObj = DateTime.parse(time).toLocal();
      //29 Sept’22, 3:33 PM
      lastSavedOn.value = _dateTimeObj.format(DateTimeFormats.dd_MMM_yy_HH_MM_a,
              lowerCaseMeridiem: true) ??
          '';
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _dispose() {
    titleController.dispose();
    bodyController.dispose();
    scrollController.dispose();
  }

  doNotSaveNoteForFirstTime() {
    return (_note == null &&
        bodyController.text == '' &&
        titleController.text == subject);
  }

  Future<bool> onBack() async {
    _saveNotes(forceUpdate: true);
    return true;
  }

  _onBodyChange() {
    _saveNotesWithDebounce();
  }

  _onTitleChange() {
    _saveNotesWithDebounce();
  }

  _scrollListener() {
    showAttachmentButton.value = false;
    _scrollDebounce.call(
        callBack: () {
          if (!showAttachmentButton.value) {
            showAttachmentButton.value = true;
          }
        },
        milliseconds: 300);
  }

  onNotesDelete() {
    onNoteUpdateCallBack(null);
    if (_note != null) _noteRepo.deleteNote(_note!.id.toString());
    Get.back();
  }

  onAttachmentDelete(int id) async {
    _noteRepo.deleteAttachment(id.toString());
    attachments.removeWhere(
        (NotesAttachmentModel _attachment) => _attachment.id == id);
    onNoteUpdateCallBack(_note);
  }

  onNotesShare() async {
    final String _title = titleController.text;
    final String _body = bodyController.text;
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(_title,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(_body),
            ),
          ]);
        }));
    AnalyticEvents.noteShare(subject, _title, lectureStartTime);
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Notes.pdf");
    await file.writeAsBytes(await pdf.save());
    Share.shareFiles([file.path]);
  }

  onUploadClick() {
    if (Get.context == null) return;
    showMyBottomModalSheet(Get.context!, UploadPhotoWidget(
      onChoseImage: (SSFile? ssFile) {
        Get.back();

        _uploadFile(ssFile);
      },
    ), title: 'Upload Photo', color: HubColor.white);
  }

  //saves only title and description of the note with debouncing
  _saveNotesWithDebounce() {
    _notesUpdateDebounce.call(callBack: _saveNotes, milliseconds: 2000);
  }

  bool _isNotesSaving = false;
  //saves only title and description of the note
  _saveNotes({bool forceUpdate = false}) async {
    if (doNotSaveNoteForFirstTime()) return;
    final String title = titleController.text;
    final String body = bodyController.text;

    if (title.isEmpty) {
      return;
    }
    if ((!forceUpdate) && _isNotesSaving) return;

    try {
      _isNotesSaving = true;
      _note = await _noteRepo.createUpdateNotes(
          title: title,
          body: body,
          eventId: eventId,
          noteId: _note?.id,
          lectureType: lectureType);
      updateLastSaved(_note!.modified);
      //preserving attachments since from backend attachments are not updated
      _note!.attachments = attachments;
      onNoteUpdateCallBack(_note);
    } catch (e) {
      debugPrint('error in saving notes');
      debugPrint(e.toString());
    }
    _isNotesSaving = false;
  }

  _uploadFile(SSFile? file) async {
    if (file == null) return;
    startFileUploading();
    try {
      final NotesModel tempNote = await _noteRepo.createUpdateNotes(
          title: titleController.text,
          body: bodyController.text,
          eventId: eventId,
          noteId: _note?.id,
          lectureType: lectureType,
          file: file);

      _updateFileLocally(tempNote);
      updateLastSaved(_note!.modified);

      onNoteUpdateCallBack(_note);
      final String name = tempNote.attachments.first.name;

      final String type =
          tempNote.attachments.first.name.contains('pdf') ? 'pdf' : 'image';
      AnalyticEvents.noteAttachFileEvent(subject, name, type, lectureStartTime);
    } catch (e) {
      debugPrint('error in saving notes');
      debugPrint(e.toString());
    }
    stopUploading();
  }

  //for loading placeholder widget
  final NotesAttachmentModel _noteLoadingModel =
      NotesAttachmentModel(id: -1, url: '', name: '');

  startFileUploading() {
    attachments.add(_noteLoadingModel);
  }

  stopUploading() {
    attachments.remove(_noteLoadingModel);
  }

  _updateFileLocally(NotesModel note) {
    _note ??= note;
    if (note.attachments.isEmpty) return;
    final NotesAttachmentModel attachmentTemp = note.attachments.first;
    attachments.add(attachmentTemp);
    onNoteUpdateCallBack(_note);
  }
}
