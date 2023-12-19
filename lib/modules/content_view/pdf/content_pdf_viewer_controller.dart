import 'dart:typed_data';
import 'package:admin_hub_app/base/base_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/content_download_mixin.dart';
// import 'package:hub/academic_content/content_view/utils/content_download_mixin.dart';
// import 'package:hub/ui/base_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ContentPDFViewerController extends BaseController with DownloadMixin {
  final String pdfDownloadUrl;
  final int? id;

  ContentPDFViewerController({required this.pdfDownloadUrl, this.id});

  Uint8List? downloadedPdfBytes;
  PdfViewerController? pdfViewerController;

  final Rx<bool?> shouldLoadFromDownloads = Rx<bool?>(null);

  @override
  void onInit() {
    _checkIfUrlDownloaded();
    super.onInit();
  }

  void _checkIfUrlDownloaded() async {
    final downloadedFilePath = await checkIfFileDownloaded();
    if (downloadedFilePath == null) {
      shouldLoadFromDownloads.value = false;
    } else {
      shouldLoadFromDownloads.value = true;
    }
  }

  @override
  void onClose() {
    pdfViewerController?.dispose();
    super.onClose();
  }

  @override
  DownloadUrlData get downloadUrlData =>
      DownloadUrlData(uniquePrefix: id.toString(), url: pdfDownloadUrl);
}