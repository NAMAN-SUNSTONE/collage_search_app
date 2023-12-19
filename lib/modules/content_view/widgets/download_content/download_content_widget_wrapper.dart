import 'package:admin_hub_app/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../../../attendance_report/model/academic_content_model.dart';
import '../../utils/content_download_mixin.dart';
import 'download_status.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/utils/content_download_mixin.dart';
// import 'package:hub/academic_content/content_view/widgets/download_content/download_status.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/theme/typography.dart';
// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/widgets/reusables.dart';

class ContentDownloadButton extends StatelessWidget {
  final Content content;
  final EdgeInsets padding;

  ///for triggering analytics events
  final Function? onDownloadClick;

  const ContentDownloadButton(
      {Key? key,
      required this.padding,
      required this.content,
      this.onDownloadClick});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContentDownloadButtonController(content),
        tag: content.id.toString());
    return InkWell(
      onTap: () {
        onDownloadClick?.call();
        controller.onDownloadOrViewClick();
      },
      child: Obx(() => Padding(
            padding: padding,
            child: DownloadStatusWidgetText(
              downloadStatus: controller.rxDownloadStatus.value,
              progress: controller.rxDownloadProgress.value,
              color: HubColor.grey1,
            ),
          )),
    );
  }
}

class ContentDownloadButtonController extends BaseController
    with DownloadMixin {
  final Content content;

  ContentDownloadButtonController(this.content);

  @override
  void onInit() {
    checkIfFileDownloaded();
    super.onInit();
  }

  @override
  DownloadUrlData get downloadUrlData => DownloadUrlData(
      url: content.target!.redirectUrl, uniquePrefix: content.id.toString());
}
