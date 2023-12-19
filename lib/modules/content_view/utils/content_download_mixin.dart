import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';
import '../../../utils/background_downloader/background_downloader.dart';
// import 'package:hub/data/student/models/target_model.dart';
// import 'package:hub/sunstone_base/utils/background_downloader/background_downloader.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/utils/extensions.dart';
// import 'package:hub/utils/navigator/navigator.dart';
import 'package:open_filex/open_filex.dart';

///Required data to download file.
class DownloadUrlData {
  ///[url] is the url from where file will be downloaded
  String url;
  /// [uniquePrefix] is used to identify the file, if not provided, it will be downloaded with the same name as redirectUrl
  String? uniquePrefix;

  DownloadUrlData({required this.url, this.uniquePrefix});
}

///This mixin can be mixed with getx controller, it provides download functionality and also checks if file is already downloaded, provides states as well.
mixin DownloadMixin {
  DownloadUrlData get downloadUrlData;

  final SSBackgroundDownloader ssBackgroundDownloader =
      SSBackgroundDownloader();

  String? get redirectUrl => downloadUrlData.url;

  String? get uniquePrefix => downloadUrlData.uniquePrefix?.toString();

  RxString rxDownloadedContentFilePath = ''.obs;

  RxDouble rxDownloadProgress = 0.0.obs;

  Rx<DownloadStatus?> rxDownloadStatus = Rx<DownloadStatus?>(null);

  ///[checkIfFileDownloaded] should be called before this
  bool get isContentDownloaded => rxDownloadedContentFilePath.value.isNotEmpty;

  ///Download content's redirectUrl
  void downloadContent() async {
    if (redirectUrl != null) {
      await ssBackgroundDownloader
          .download(redirectUrl!, openFile: true, uniquePrefix: uniquePrefix,
              downloadStatusCallback: (DownloadStatus status) {
        rxDownloadStatus.value = status;

        if (status == DownloadStatus.complete) {
          checkIfFileDownloaded();
        }
      }, downloadProgressCallback: (double progress) {
        rxDownloadProgress.value = progress;
      });
    }
  }

  ///Check if content's redirectUrl is already downloaded
  Future<String?> checkIfFileDownloaded() async {
    debugPrint('checkIfFileDownloaded');
    debugPrint(
        'unique prefix : ${uniquePrefix}  redirect url : ${redirectUrl} ');
    rxDownloadStatus.value = null;

    if (redirectUrl != null) {
      final String? downloadedContentFilePath = await ssBackgroundDownloader
          .getFilePath(downloadURL: redirectUrl!, uniquePrefix: uniquePrefix);
      if (downloadedContentFilePath != null) {
        rxDownloadedContentFilePath.value = downloadedContentFilePath;
        rxDownloadStatus.value = DownloadStatus.complete;
        return downloadedContentFilePath;
      }
    }
    return null;
  }

  void viewAlreadyDownloadedFile() {
    OpenFilex.open(rxDownloadedContentFilePath.value).then((result) {
      // if (result.type == ResultType.noAppToOpen) {
      //   onNoFileToOpenError();
      // }
    });
  }
///If device doesn't have any app to open the file, this method will be called on click of snackbar
//   void onNoFileToOpenError() {
//     final String fileExt = rxDownloadedContentFilePath
//         .value.shortFileNameWithExtension
//         .split('.')
//         .last;
//     Get.showSnackbar(GetSnackBar(
//       title: 'Unable to open the file',
//       message: "Click here to download the file opener ",
//       isDismissible: true,
//       duration: 5.seconds,
//       backgroundColor: HubColor.redLight,
//       onTap: (snackBar) {
//         SHNavigationManager.navigate(Target(
//             identifier: Identifiers.browser,
//             value: '',
//             title: '',
//             redirectUrl:
//                 'https://play.google.com/store/search?q=${fileExt}&c=apps&hl=en&gl=US'));
//       },
//     ));
//   }
///Checks weather to download or view the file
  void onDownloadOrViewClick() {
    if (DownloadStatus.failed == rxDownloadStatus.value ||
        null == rxDownloadStatus.value) {
      downloadContent();
    } else if (DownloadStatus.complete == rxDownloadStatus.value) {
      viewAlreadyDownloadedFile();
    }
  }
}
