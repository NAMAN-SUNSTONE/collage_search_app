import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/base/academic_content_model.dart';
// import 'package:hub/academic_content/content_view/widgets/download_content/download_content.dart';
import 'package:sunstone_ui_kit/typo/typography.dart';

import '../../attendance_report/model/academic_content_model.dart';
import '../widgets/download_content/download_content.dart';

class GenericContent extends StatelessWidget {
  final Content content;

  const GenericContent({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content.title,
              style: UIKitDefaultTypography().headline5,
            ),
          ),
          DownloadContentCard(content: content)
        ],
      );

  }
}
