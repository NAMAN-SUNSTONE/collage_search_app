import 'package:flutter/foundation.dart';

import 'background_downloader_mobile.dart';
// import 'package:hub/sunstone_base/utils/background_downloader/background_donwloader_web.dart';
// import 'package:hub/sunstone_base/utils/background_downloader/background_downloader_mobile.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/multiplatform.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/ss_platform.dart';


enum DownloadStatus { downloading, failed, complete }

typedef DownloadStatusCallback = void Function(DownloadStatus status);
typedef DownloadProgressCallback = void Function(double progress);

abstract class SSBackgroundDownloader {
  void init();

  Future<void> download(String downloadURL, {bool openFile = false,  String? uniquePrefix, DownloadStatusCallback? downloadStatusCallback, DownloadProgressCallback? downloadProgressCallback });

  Future<String?> getFilePath({required String downloadURL, String? uniquePrefix});



  factory SSBackgroundDownloader() {
    // if (getPlatform() == SSPlatform.android ||
    //     getPlatform() == SSPlatform.ios) {
      return SSBackgroundDownloaderMobile();
    // } else if (kIsWeb) {
    //   return SSBackgroundDownloaderWeb();
    // } else {
    //   throw UnimplementedError('Unsupported');
    // }
  }
}
