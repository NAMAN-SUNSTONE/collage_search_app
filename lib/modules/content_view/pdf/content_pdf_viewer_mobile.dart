import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'content_pdf_viewer_controller.dart';
// import 'package:hub/academic_content/content_view/pdf/content_pdf_viewer_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ContentPDFViewerMobile extends GetView<ContentPDFViewerController> {
  final String pdfDownloadUrl;
  final int? id;

  ContentPDFViewerMobile({Key? key, required this.pdfDownloadUrl, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContentPDFViewerController>(
        init: ContentPDFViewerController(pdfDownloadUrl: pdfDownloadUrl, id: id),
        tag: key.toString(),
        global: false,
        builder: (controller) {
          return Obx(() {
            return Container(
              child: controller.shouldLoadFromDownloads.value == null
                  ? SizedBox.shrink()
                  : controller.shouldLoadFromDownloads.value!
                  ? SfPdfViewer.file(
                File.fromUri(Uri.parse(
                    controller.rxDownloadedContentFilePath.value)),
                enableTextSelection: false,
              )
                  : SfPdfViewer.network(
                pdfDownloadUrl,
                enableTextSelection: false,
              ),
            );
          });
        });
  }
}
