import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../generated/assets.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/typography.dart';
import '../../../../utils/background_downloader/background_downloader.dart';
import '../../../../widgets/reusables.dart';
// import 'package:hub/app_assets/app_svg_path.dart';
// import 'package:hub/sunstone_base/utils/background_downloader/background_downloader.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/theme/typography.dart';
// import 'package:hub/widgets/reusables.dart';

class DownloadStatusWidget extends StatelessWidget {
  final DownloadStatus? downloadStatus;
  final double progress;
  final Color color;

  DownloadStatusWidget(
      {Key? key,
      this.downloadStatus,
      required this.progress,
      this.color = HubColor.primary});

  @override
  Widget build(BuildContext context) {
    switch (downloadStatus) {
      case DownloadStatus.downloading:
        return Container(
          height: 32,
          width: 32,
          child: FittedBox(
            child: Center(
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: HubColor.greyDC,
              ),
            ),
          ),
        );

      case DownloadStatus.complete:
        return Icon(
          Icons.open_in_new_rounded,
          size: 20,
          color: color,
        );

      case DownloadStatus.failed:
        return Icon(
          Icons.refresh,
          color: HubColor.redDark,
        );

      default:
        return SvgPicture.asset(
          Assets.svgDownload3,
          color: color,
        );
    }
  }
}

class DownloadStatusWidgetText extends StatelessWidget {
  final DownloadStatus? downloadStatus;
  final double progress;
  final Color color;

  DownloadStatusWidgetText(
      {Key? key,
      this.downloadStatus,
      required this.progress,
      this.color = HubColor.primary});

  Text getLabel() {
    switch (downloadStatus) {
      case DownloadStatus.downloading:
        return Text(
          "Downloading",
          style: HubTypography.hubTextTheme.bodyText1?.copyWith(
              fontSize: 12, fontWeight: FontWeight.w600, color: color),
        );

      case DownloadStatus.complete:
        return Text(
          "View",
          style: HubTypography.hubTextTheme.bodyText1?.copyWith(
              fontSize: 12, fontWeight: FontWeight.w600, color: color),
        );

      case DownloadStatus.failed:
        return Text(
          "Failed",
          style: HubTypography.hubTextTheme.bodyText1?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: HubColor.redDark),
        );

      default:
        return Text(
          "Download",
          style: HubTypography.hubTextTheme.bodyText1?.copyWith(
              fontSize: 12, fontWeight: FontWeight.w600, color: color),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.max,
      children: [
        DownloadStatusWidget(
          downloadStatus: downloadStatus,
          progress: progress,
          color: color,
        ),
        SpaceHorizontal(
          width: 10,
        ),
        getLabel()
      ],
    );
  }
}
