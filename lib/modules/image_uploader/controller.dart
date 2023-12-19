import 'dart:io';

import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/modules/schedule/repo/schedule_repo.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:admin_hub_app/utils/ss_file.dart';
import 'package:admin_hub_app/widgets/view_image/view_image_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploaderArguments {
  late LectureEventListModel event;
  final void Function()? onNext;

  ImageUploaderArguments(this.event, {this.onNext});
}

class ImageUploaderController extends BaseController {
  final ImagePicker _picker = ImagePicker();
  final ScheduleRepo _repo = Get.find<ScheduleRepo>();
  late final LectureEventListModel _event;
  RxList<SSFile> images = RxList<SSFile>();
  String get title => _event.displayTitle;
  late final Function()? onNext;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments is! ImageUploaderArguments) {
      throw Exception('Please provide the correct arguments');
    }
    final ImageUploaderArguments args = Get.arguments;
    _event = args.event;
    onNext = args.onNext;
    success();
    await _getImages();
  }

  Future<void> _getImages() async {
    images.addAll(_event.classPictures.map((e) => SSFile(location: SSFileLocation.network, path: e)).toList());
    List<String> localImages = await DatabaseHelper.fetchAttendanceImagesByEventId(eventId: _event.id);
    images.addAll(localImages.map((e) => SSFile(location: SSFileLocation.local, path: e)));
    images.refresh();
  }

  onAddImage() async {
    loading();
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          if (await ConnectivityManager.isOnline()) {
            final List<String> imageList = await _repo
                .uploadPhoto(timeTableId: _event.id, files: [File(photo.path)]);
            if (imageList.isNotEmpty) {
              images.addAll(imageList.map((e) =>
                  SSFile(location: SSFileLocation.network, path: e)));
            }
          }
          else {
            await DatabaseHelper.insertAttendanceImage(
                eventId: _event.id, path: photo.path);
            images.add(
                SSFile(location: SSFileLocation.local, path: photo.path));
          }
        }
    } catch (e) {
      showErrorMessage(e.toString());
    }
    success();
  }

  onPhotoTap(SSFile image) {
    Get.toNamed(Paths.viewImage,
        arguments: ViewImageArgument(image: image, title: "Class pic"));
  }

  onDone() {
    if (onNext != null) onNext!();
  }
}
