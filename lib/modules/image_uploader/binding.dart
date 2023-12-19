import 'package:admin_hub_app/modules/image_uploader/controller.dart';
import 'package:get/get.dart';

class ImageUploaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageUploaderController>(() => ImageUploaderController(),
        fenix: true);
  }
}
