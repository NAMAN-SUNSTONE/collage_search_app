import 'dart:io';
import 'package:admin_hub_app/modules/content_view/assignments/widgets/exit_without_submit_popup.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/assignments/content_assignment_repo.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/exit_without_submit_popup.dart';
// import 'package:hub/academic_content/content_view/assignments/widgets/re-upload-popup.dart';
// import 'package:hub/academic_content/content_view/content_view_controller.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/network/ss_action_exception.dart';
// import 'package:hub/sunstone_base/data/ss_file.dart';

// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/utils/extensions.dart';
// import 'package:hub/widgets/reusables.dart';

import '../../../base/base_controller.dart';
import '../../../constants/enums.dart';
import '../../../network/ss_action_exception.dart';
import '../../../utils/ss_file.dart';
import '../../../widgets/reusables.dart';
import '../../attendance_report/model/academic_content_model.dart';
import '../content_view_controller.dart';
// import 'content_assignment_repo.dart';

class SelectedFile {
  SSFile ssFile;
  Rx<Status> status;
  String? url;

  SelectedFile({required this.ssFile, required this.status, this.url});
}

class ContentAssignmentController extends BaseController {
  final Content assignmentContent;
  final Function(LmsAssessmentModel)? onAssignmentUpdate;
  final int subjectId;

  ContentAssignmentController(
      {required this.assignmentContent,
      required this.subjectId,
      this.onAssignmentUpdate});

  Rx<List<SelectedFile>>? selectedFiles = Rx<List<SelectedFile>>([]);

  bool get hasSelectedFiles => selectedFiles?.value.isNotEmpty ?? false;

  /// For managing back and next button state
  final ContentViewController contentViewController = Get.find();

  late Rx<LmsAssessmentModel?> assignment =
      Rx<LmsAssessmentModel?>(assignmentContent.assignment);

  final assignmentSubmitStatus = Status.init.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void onSelectFile() async {
    FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    try {
      /// Using bytes as it is supported for both web and mobile platforms
      List<SelectedFile>? pickedFiles = filePickerResult?.files.map((file) {
        final SSFile ssFile = SSFile(
          bytes: /*isWeb ? file.bytes :*/ File(file.path!).readAsBytesSync(),
          file: /*isMobile ?*/ File(file.path!) /*: null*/,
          fileName: file.name,
          path: file.path,
          extension: file.extension,
          identifier: file.path,
          location: SSFileLocation.local,
        );

        return SelectedFile(
          ssFile: ssFile,
          status: Status.init.obs,
        );
      }).toList();

      selectedFiles?.value.addAll(pickedFiles!);

      if (selectedFiles != null) {
        selectedFiles?.refresh();
        hideBackNextButton(true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

  }

  void hideBackNextButton(bool hide) {
    contentViewController.hideBackButtonForce.value = hide;
    contentViewController.hideNextButtonForce.value = hide;
  }

  String get uploadPlaceholderText {
    if (selectedFiles?.value.isEmpty ?? true) {
      return 'Upload File';
    } else {
      return 'Upload more files';
    }
  }

  // final ContentAssignmentRepo _contentAssignmentRepo = ContentAssignmentRepo();

  Future<bool> submitAssignment() async {
    final List<String>? uploadedUrl =
        selectedFiles?.value.map((data) => data.url!).toList();

    try {
      // assignment.value = await _contentAssignmentRepo.submitAssignment(
      //     uploadedUrl!, assignment.value!.id, subjectId );
      assignmentSubmitStatus.value = Status.success;
      selectedFiles?.value.clear();
      selectedFiles?.refresh();

      if (assignment.value != null) {
        onAssignmentUpdate?.call(assignment.value!);
      }

      // AnalyticEvents.lmsAssignmentSubmitted(
      //   contentTitle: assignmentContent.title,
      // );

      hideBackNextButton(false);
      Fluttertoast.showToast(msg: 'Assignment Submitted');

      return true;
    } catch (e) {
      showErrorMessage((e as SSActionException).errorMsg.toString());
      assignmentSubmitStatus.value = Status.error;
      return false;
    }
  }

  void onSubmitAssignment() async {
    submitAssignment();
  }

  void onResubmitAssignment() {
    // showMyBottomModalSheet(
    //   Get.context!,
    //   ReUploadAssignmentPopup(
    //     onYes: () {
    //       onSelectFile();
    //     },
    //   ),
    //   title: 'Re-upload Assignment',
    // );
  }

  String get assignmentFileName {
    return assignmentContent.target?.redirectUrl.shortFileNameWithExtension ??
        '';
  }

  String get title {
    return (assignmentContent.target?.title.isEmpty ?? true)
        ? 'Document'
        : assignmentContent.target!.title;
  }

  bool get isAssignmentAlreadySubmitted {
    return assignment.value?.status == AssignmentStatus.Submitted;
  }

  bool get shouldEnableUploadWidget {
    // if the assignment is overdue, simply disallow upload
    if (assignment.value?.status == AssignmentStatus.Overdue) {
      return false;
    }

    if (selectedFiles?.value.isNotEmpty ?? false) {
      return true;
    }

    final bool isAlreadySubmitted = [
      AssignmentStatus.Submitted,
      AssignmentStatus.Graded
    ].contains(assignment.value?.status);

    return !isAlreadySubmitted;
  }


  Future<bool> onExit() async{

    bool isCancel = false;
    if (hasSelectedFiles) {
      showMyBottomModalSheet(
        Get.context!,
        ExitWithoutSubmit(
          onYes: () {
            isCancel = false;
          },
          onCancel: () {
            isCancel = true;
          },
          title: 'You haven’t submit assignment',
          description: 'Files you have uploaded will be discarded due to not submitting the assignment. Are you sure you want to cancel submission?',
          yesText: 'Continue Submission',
          cancelText: 'Discard Submission',
        ),
        title: 'Exit without submitting?',
      );
      return Future.value(isCancel);
    }
    else {
      return Future.value(true);
    }

  }

  void onDiscard() async{
   final bool onExitSubmission =  await onExit();

   if(onExitSubmission) {
     Fluttertoast.showToast(msg: 'Files discarded');
     selectedFiles?.value = [];
     selectedFiles?.refresh();
     hideBackNextButton(false);
   }
  }

  bool get enableSubmitButton {
    if ((selectedFiles!.value
            .every((element) => element.status.value == Status.success)) &&
        hasSelectedFiles) {
      Fluttertoast.showToast(msg: 'Files uploaded');
      return true;
    } else if (assignmentSubmitStatus.value == Status.success) {
      return false;
    } else if (!hasSelectedFiles) {
      return false;
    } else {
      return false;
    }
  }

  void onFileUploadSuccess(String url, int index) {
    selectedFiles!.value[index].url = url;
    selectedFiles!.value[index].status.value = Status.success;
  }

  void onFileUploadError(int index) {
    Fluttertoast.showToast(msg: 'Failed to upload');
    selectedFiles!.value[index].status.value = Status.error;
  }

  void onFileRemove(int index) {
    selectedFiles!.value.removeAt(index);
    selectedFiles!.refresh();
    if(selectedFiles!.value.isEmpty) {
      hideBackNextButton(false);
    }
  }
}
