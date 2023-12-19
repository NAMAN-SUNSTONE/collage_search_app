import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/content_view/pdf/content_pdf_viewer_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'content_pdf_viewer_controller.dart';

class ContentPDFViewerWeb extends StatelessWidget {
  final String pdfDownloadUrl;
  final int? id;

  ContentPDFViewerWeb({Key? key, required this.pdfDownloadUrl, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContentPDFViewerController>(
        init:
            ContentPDFViewerController(pdfDownloadUrl: pdfDownloadUrl, id: id),
        tag: key.toString(),
        global: false,
        builder: (controller) {
          return Obx(() {
            return Container(
              child: SfPdfViewer.network(
                pdfDownloadUrl,
                enableTextSelection: false,
              ),
            );
          });
        });
  }
}
