import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:admin_hub_app/base/base_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_downloader/download_helper.dart';
// import 'package:hub/sunstone_base/utils/background_downloader/background_downloader.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/multiplatform.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/ss_platform.dart';
import 'package:path_provider/path_provider.dart';

import 'background_downloader.dart';

// import '../../../ui/base_controller.dart';

@protected
class SSBackgroundDownloaderMobile extends BaseController
    implements SSBackgroundDownloader {
  @override
  void init() {
    _setupDownloadNotification();
  }

  void _myDownloadStatusCallback(Task task, TaskStatus status) {
    if (status == TaskStatus.complete) {
      debugPrint('Download is complete');
    } else if (status == TaskStatus.running) {
      debugPrint('Download is running');
    } else {
      debugPrint('Download is $status');
    }
  }

  /// Process the progress updates coming from the downloader
  /// Adds an update object to the stream that the main UI listens to
  void _myDownloadProgressCallback(Task task, double progress) {}

  /// Process the user tapping on a notification by printing a message
  ///todo: Not working
  void _myNotificationTapCallback(
      Task task, NotificationType notificationType) {
    print('Tapped notification $notificationType for taskId ${task.taskId}');
  }

  void _setupDownloadNotification() {
    FileDownloader()
        .registerCallbacks(
            taskProgressCallback: _myDownloadProgressCallback,
            taskStatusCallback: _myDownloadStatusCallback,
            taskNotificationTapCallback: _myNotificationTapCallback)
        .configureNotification(
          complete:
              TaskNotification('Downloaded {filename}', 'Download complete'),
          running: TaskNotification(
              'Downloading {filename}', 'File: {filename} - {progress}'),
          error: TaskNotification('Download {filename}', 'Download failed'),
          paused: TaskNotification(
              'Download {filename}', 'Paused with metadata {metadata}'),
        )
        .configureNotificationForGroup(
          FileDownloader.defaultGroup,
          // For the main download button
          // which uses 'enqueue' and a default group,

          running: TaskNotification(
              'Downloading {filename}', 'File: {filename} - {progress}'),
          complete:
              TaskNotification('Download {filename}', 'Download complete'),
          error: TaskNotification('Download {filename}', 'Download failed'),
          paused: TaskNotification(
              'Download {filename}', 'Paused with metadata {metadata}'),
          progressBar: true,
        );
  }

  String? newFilepath;

  /// Uses normal downloader for iOS
  @override
  Future<bool> download(String downloadURL,
      {bool openFile = false,
      String? uniquePrefix,
      DownloadStatusCallback? downloadStatusCallback,
      DownloadProgressCallback? downloadProgressCallback}) async {
    //Todo: Need to use background downloader functionality in future as its plugin is currently not upgradable due to flutter version
    // if (SSPlatform.ios == getPlatform()) {
    //   downloadStatusCallback?.call(DownloadStatus.downloading);
    //   DownloadHelper.downloadFile(
    //     Uri.parse(downloadURL),
    //     uniquePrefix: uniquePrefix,
    //     onReceivedProgress: (received, total) {
    //       downloadStatusCallback?.call(DownloadStatus.downloading);
    //       downloadProgressCallback?.call(received / total * 1);
    //     },
    //     onDownloadComplete: (file) {
    //       downloadStatusCallback?.call(DownloadStatus.complete);
    //       Fluttertoast.showToast(msg: 'File downloaded');
    //     },
    //     onError: (error) {
    //       downloadStatusCallback?.call(DownloadStatus.failed);
    //       Fluttertoast.showToast(msg: 'File download failed');
    //     },
    //   );
    //
    //   return true;
    // }

    final String fileName = _createUniqueFileName(downloadURL, uniquePrefix);
    var task = DownloadTask(
      url: Uri.parse(downloadURL).toString(),
      baseDirectory: BaseDirectory.applicationDocuments,
      filename: fileName,
      group: 'defaultGroup',
    );

    TaskStatus status =
        await FileDownloader().download(task, onProgress: (progress) {
      downloadProgressCallback?.call(progress);
    }, onStatus: (TaskStatus status) async {
      if (status == TaskStatus.complete) {
        newFilepath = await FileDownloader().moveToSharedStorage(
            task, SharedStorage.downloads,
            directory: 'sunstone');

        downloadStatusCallback?.call(DownloadStatus.complete);

        Fluttertoast.showToast(msg: 'File downloaded');
        debugPrint('downloaded file path $newFilepath');
        if (openFile && newFilepath != null) {
          await FileDownloader().openFile(filePath: newFilepath);
        }
      } else if (status == TaskStatus.running) {
        downloadStatusCallback?.call(DownloadStatus.downloading);
        Fluttertoast.showToast(msg: 'Downloading...');
      } else if (status == TaskStatus.failed || status == TaskStatus.notFound) {
        downloadStatusCallback?.call(DownloadStatus.failed);
        Fluttertoast.showToast(msg: 'Downloading Failed');
      }
    });

    return status == TaskStatus.complete;
  }

  @override
  Future<String?> getFilePath(
      {required String downloadURL, String? uniquePrefix}) async {
    if (newFilepath != null) {
      return newFilepath;
    }

    final String fileName = _createUniqueFileName(downloadURL, uniquePrefix);
    final String applicationDocumentDir =
        (await getApplicationDocumentsDirectory()).path;
    final String pathToSave =
        (isIos ? applicationDocumentDir : 'storage/emulated/0/Download') +
            '/sunstone';
    final String storagePathForFile = pathToSave + '/' + fileName;
    final File file = File(storagePathForFile);
    if (await file.exists()) {
      return storagePathForFile;
    }
    return null;
  }

  String _createUniqueFileName(String url, String? uniquePrefix) {
    return (uniquePrefix ?? '') + Uri.parse(url).pathSegments.last;
  }

  bool get isIos => /*getPlatform() == SSPlatform.ios*/ false;
}
