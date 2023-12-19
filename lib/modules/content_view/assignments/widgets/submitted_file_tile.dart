import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/content_view/utils/content_download_mixin.dart';
// import 'package:hub/academic_content/content_view/widgets/download_content/download_status.dart';
// import 'package:hub/app_assets/app_image_path.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/home/ui/widgets/card_stroke.dart';
// import 'package:hub/sunstone_base/utils/background_downloader/background_downloader.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/utils/extensions.dart';
import 'package:mime/mime.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../../../widgets/card_stroke.dart';
import '../../utils/content_download_mixin.dart';
import '../../widgets/download_content/download_status.dart';

class NetworkFileThumbnailPreviewer extends StatelessWidget {
  final String url;
  final String? assessmentId;

  NetworkFileThumbnailPreviewer({
    Key? key,
    required this.url,
    this.assessmentId
  }) : super(key: key);

  Widget getThumbnail() {
    // final String mimeType = lookupMimeType(url) ?? '';
    //
    // if (mimeType.startsWith('image/')) {
    //   /// using bytes for web compatibility
    //   return Image.network(url);
    // }
    return Container(child: Image.asset(Assets.iconPdf));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NetworkFileThumbnailPreviewerController>(
        init: NetworkFileThumbnailPreviewerController(url: url, assessmentId: assessmentId),
        global: false,
        builder: (controller) {
      return Container(
        height: 55,
        child: CardStroke(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  controller.onDownloadOrViewClick();
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    SizedBox(height: 25, width: 25, child: getThumbnail()),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: Text(
                          url.shortFileNameWithExtension,
                          style: UIKitDefaultTypography().bodyText1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Padding(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16),
                        child: Obx(() {
                          return DownloadStatusWidget(
                            downloadStatus: controller.rxDownloadStatus.value,
                            progress: controller.rxDownloadProgress.value,
                          );
                        })
                    ),
                  ],
                ),
              ),
            )),
      );
    });
  }

}


class NetworkFileThumbnailPreviewerController extends BaseController
    with DownloadMixin {
  final String url;
  final String? assessmentId;

  NetworkFileThumbnailPreviewerController(
      {required this.url, this.assessmentId});

  @override
  void onInit() {
    checkIfFileDownloaded();
    super.onInit();
  }

  @override
  DownloadUrlData get downloadUrlData => DownloadUrlData(url: url, uniquePrefix: assessmentId);
}