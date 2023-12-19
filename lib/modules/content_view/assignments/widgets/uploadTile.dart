import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/app_assets/app_image_path.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/data/student/repos/profile_repo_legacy.dart';
// import 'package:hub/home/ui/widgets/card_stroke.dart';
// import 'package:hub/sunstone_base/data/ss_file.dart';
// import 'package:hub/sunstone_base/repos/base_repo.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_pdf_preview_card/pdf_preview_card.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/ss_platform.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/base_controller.dart';
// import 'package:hub/utils/extensions.dart';

import 'package:mime/mime.dart';
import 'package:sunstone_ui_kit/color/color.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../../../base/base_controller.dart';
import '../../../../constants/enums.dart';
import '../../../../theme/colors.dart';
import '../../../../utils/ss_file.dart';
import '../../../../widgets/card_stroke.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/multiplatform.dart';

typedef void OnUploadSuccess({required String url});

class UploadTile extends StatelessWidget {
  final SSFile ssFile;
  final Function? onDelete;
  final Function? onError;
  final OnUploadSuccess? onUploadSuccess;
  final int index;

  Widget getThumbnail() {
    // final String mimeType = lookupMimeType(ssFile.file!.path) ?? '';

    // if (mimeType.startsWith('image/')) {
    //   /// using bytes for web compatibility
    //   return Image.memory(
    //     ssFile.bytes!,
    //     fit: BoxFit.cover,
    //   );
    // } else if (mimeType == ('application/pdf') &&
    //     getPlatform() != SSPlatform.web) {
    //   return SSPDFPreviewCard.file(file: ssFile.file!);
    // }

    return Container(child: Image.asset(Assets.iconPdf));
  }

  const UploadTile(
      {Key? key,
      required this.ssFile,
      required this.index,
      this.onDelete,
      this.onError,
      this.onUploadSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadTileController>(
        global: false,
        init: UploadTileController(
            ssFile: ssFile,
            onUploadSuccess: ({required String url}) {
              onUploadSuccess?.call(url: url);
            }),
        builder: (controller) {
          return Obx(() {
            var shortFileNameWithExtension;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardStroke(
                    child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      if (controller.status != Status.error) ...[
                        SizedBox(height: 25, width: 25, child: getThumbnail()),
                      ],
                      if (controller.status == Status.error)
                        Icon(
                          Icons.error_outline_rounded,
                          size: 20,
                          color: HubColor.redNormal,
                        ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Text(
                        ssFile.fileName?.shortFileNameWithExtension ?? 'File',
                        style: UIKitDefaultTypography().bodyText1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      if (controller.status == Status.error) ...[
                        IconButton(
                            onPressed: () {
                              controller.onRetry();
                            },
                            splashRadius: 20,
                            icon: Icon(Icons.refresh_rounded)),
                      ],
                      IconButton(
                          padding: EdgeInsets.zero,
                          splashRadius: 20,
                          onPressed: () {
                            onDelete?.call();
                            controller.onFileRemoved();
                          },
                          icon: Icon(
                            Icons.delete_outline_outlined,
                            color: HubColor.redNormal,
                          )),
                      if (controller.status == Status.loading) ...[
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  UIKitColor.success1),
                            )),
                        SizedBox(
                          width: 12,
                        ),
                      ]
                    ],
                  ),
                )),
                if (controller.status == Status.error)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'File upload failed',
                      style: UIKitDefaultTypography()
                          .bodyText2
                          .copyWith(color: HubColor.redNormal),
                    ),
                  )
              ],
            );
          });
        });
  }
}

class UploadTileController extends BaseController {
  final SSFile ssFile;
  final OnUploadSuccess? onUploadSuccess;

  UploadTileController({required this.ssFile, this.onUploadSuccess});

  @override
  void onInit() {
    // uploadAssignments();
    super.onInit();
  }

  // Future<void> uploadAssignments() async {
  //   final BaseRepo _baseRepo = Get.find();
  //
  //   try {
  //     updateStatus(Status.loading);
  //
  //     final uploadedFile = await _baseRepo.uploadFile(
  //         ssFile: ssFile, folderName: 'lms/assignment_solutions');
  //
  //     if (uploadedFile != null) {
  //       onUploadSuccess?.call(url: uploadedFile.shortUrl);
  //       updateStatus(Status.success);
  //     } else {
  //       updateStatus(Status.init);
  //       updateStatus(Status.error);
  //       debugPrint('Uploaded file is null');
  //     }
  //   } catch (e) {
  //     updateStatus(Status.init);
  //     updateStatus(Status.error);
  //     debugPrint(e.toString());
  //   }
  // }

  onRetry() {
    // uploadAssignments();
  }

  onFileRemoved() {
    //todo: need to cancel the upload API execution
    Get.delete<UploadTileController>(tag: ssFile.file!.path);
  }
}
