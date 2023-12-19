// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/utils/content_download_mixin.dart';
// import 'package:hub/ui/base_controller.dart';

import 'package:admin_hub_app/base/base_controller.dart';

import '../../../attendance_report/model/academic_content_model.dart';
import '../../utils/content_download_mixin.dart';

class DownloadContentController extends BaseController with DownloadMixin {
  final Content content;

  DownloadContentController(this.content);

  @override
  void onInit() {
    checkIfFileDownloaded();
    super.onInit();
  }

  void onCardTap() {
    onDownloadOrViewClick();
  }

  @override
  DownloadUrlData get downloadUrlData => DownloadUrlData(
      url: content.target!.redirectUrl!,
      uniquePrefix: content.id.toString());
}