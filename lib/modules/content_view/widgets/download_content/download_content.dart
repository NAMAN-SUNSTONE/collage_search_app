import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/widgets/download_content/download_content_controller.dart';
// import 'package:hub/academic_content/content_view/widgets/download_content/download_status.dart';
// import 'package:hub/app_assets/app_image_path.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/string_extension.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../../../generated/assets.dart';
import '../../../../theme/colors.dart';
import '../../../attendance_report/model/academic_content_model.dart';
import 'download_content_controller.dart';
import 'download_status.dart';

class DownloadContentCard extends StatelessWidget {
  final Content content;

  const DownloadContentCard({Key? key, required this.content});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadContentController>(
        init: DownloadContentController(content),
        global: false,
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                controller.onCardTap();
              },
              child: Container(
                height: 74,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: HubColor.grey1.withOpacity(0.1))),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    Image.asset(
                      Assets.iconPdf,
                      height: 42,
                      width: 42,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            content.target?.redirectUrl
                                    .shortFileNameWithExtension ??
                                'NA',
                            maxLines: 2,
                            style: UIKitDefaultTypography().headline6,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      return DownloadStatusWidget(
                        progress: controller.rxDownloadProgress.value,
                        downloadStatus: controller.rxDownloadStatus.value,
                      );
                    }),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}