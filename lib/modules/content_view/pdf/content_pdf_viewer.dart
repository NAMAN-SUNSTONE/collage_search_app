import 'package:flutter/material.dart';
// import 'package:hub/academic_content/content_view/pdf/content_pdf_viewer_mobile.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/multiplatform.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/ss_platform.dart';

import 'content_pdf_viewer_mobile.dart';
import 'content_pdf_viewer_web.dart';

class ContentPDFViewer extends StatelessWidget {
  final String pdfDownloadUrl;
  final int? id;

  const ContentPDFViewer({Key? key, required this.pdfDownloadUrl, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // switch (getPlatform()) {
    //   case SSPlatform.web:
    //     return ContentPDFViewerWeb(
    //       key: key,
    //       pdfDownloadUrl: pdfDownloadUrl,
    //       id: id,
    //     );
    //   default:
        return ContentPDFViewerMobile(
          key: key,
          pdfDownloadUrl: pdfDownloadUrl,
          id: id,
        );
    // }
  }
}
