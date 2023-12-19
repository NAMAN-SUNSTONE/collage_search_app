import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/data/student/student.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_downloader/ss_download_button.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/layout.dart';

import 'single_row_text_widget.dart';

class Attachments extends StatelessWidget {
  final List<AttachmentModel> attachments;

  const Attachments({Key? key, this.attachments = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: double.infinity,
      child: Row(
        children: [
          RowIcon(
            svgIconPath: Assets.svgAttachment,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: attachments.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              separatorBuilder: (_, i) {
                return SizedBox(
                  width: 8,
                );
              },
              itemBuilder: (context, index) {
               return AttachmentChip(attachment: attachments[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}


class AttachmentChip extends StatelessWidget {
  AttachmentChip({Key? key, required this.attachment}) : super(key: key);

  final AttachmentModel attachment;

  @override
  Widget build(BuildContext context) {
    if (attachment.url == null) {
      return SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: HubColor.grey1.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      //todo cht
      // child: SSDownloadButton(
      //   uri: Uri.parse(attachment.url!),
      //   leading: Container(
      //    constraints: BoxConstraints(
      //      maxWidth: Layout.childWidth * 0.4
      //    ),
      //     padding: EdgeInsets.symmetric(horizontal: 12),
      //     child: Text(
      //       attachment.title ?? Uri.parse(attachment.url!).pathSegments.last,
      //       overflow: TextOverflow.ellipsis,
      //       maxLines: 1,
      //       style: context.textTheme.bodyText2?.copyWith(
      //           color: HubColor.primary,
      //           fontWeight: FontWeight.w400,
      //           fontSize: 14,
      //           decoration: TextDecoration.underline),
      //     ),
      //   ),
      // ),
    );
  }
}