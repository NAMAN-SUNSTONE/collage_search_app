import 'dart:io';

import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/modules/content_view/video/ss_video_player.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/content_view/utils/content_download_mixin.dart';
// import 'package:hub/academic_content/content_view/video/ss_video_player.dart';
// import 'package:hub/academic_content/content_view/widgets/ss_video_player_controls.dart';
// import 'package:hub/community/ui/feed/feed_controller.dart';
// import 'package:hub/ui/base_controller.dart';
import 'package:wakelock/wakelock.dart';

import '../utils/content_download_mixin.dart';
import '../widgets/ss_video_player_controls.dart';

class SSVideoPlayerControllerMobile extends BaseController with DownloadMixin {
  ///Streamable [videoUrl] - M3u8, Avi, Mp4 etc.
  final String videoUrl;

  final SSVideoPlayerOptions? options;

  final int? id;

  SSVideoPlayerControllerMobile(
      {required this.videoUrl, this.options, this.id});

  BetterPlayerController? betterPlayerController;

  final shouldRenderPlayer = false.obs;

  List<int> downloadVideoBytes = [];

  late BetterPlayerDataSource betterPlayerDataSource;

  String? localFilePath;

  @override
  void onInit() {
    initVideoPlayer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onInit();
  }

  @override
  void onClose() {
    betterPlayerController?.dispose(forceDispose: true);
    super.onClose();
  }

  BetterPlayerDataSource get betterPlayerLocalDataSource {
    try {
      return BetterPlayerDataSource.memory(downloadVideoBytes);
    } catch (er) {
      return betterPlayerNetworkDataSource;
    }
  }

  BetterPlayerDataSource get betterPlayerNetworkDataSource =>
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        Uri.parse(videoUrl).toString(),
      );

  Future<void> _setupVideoSource() async {
    localFilePath = await checkIfFileDownloaded();
    if (localFilePath != null) {
      downloadVideoBytes = await File(localFilePath!).readAsBytes();
      betterPlayerDataSource = betterPlayerLocalDataSource;
    } else {
      betterPlayerDataSource = betterPlayerNetworkDataSource;
    }
  }

  void initVideoPlayer() async {
    await _setupVideoSource();
    shouldRenderPlayer.value = true;
    betterPlayerController = BetterPlayerController(

      BetterPlayerConfiguration(
          looping: options?.loop ?? false,
          autoDetectFullscreenDeviceOrientation: true,
          autoDetectFullscreenAspectRatio: true,
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
          autoPlay: true,
          fit: BoxFit.contain,
          aspectRatio: 16 / 9,
          autoDispose: true,
          eventListener: (event) {
            if (event.betterPlayerEventType == BetterPlayerEventType.play) {
              Wakelock.enable();
            } else if (event.betterPlayerEventType ==
                BetterPlayerEventType.pause) {
              Wakelock.disable();
            }
          },
          allowedScreenSleep: false,

          controlsConfiguration: BetterPlayerControlsConfiguration(
            playerTheme: options?.mode == SSVideoPlayerMode.community ? BetterPlayerTheme.custom : null,
            customControlsBuilder: options?.mode == SSVideoPlayerMode.community ? (controller, _) => SSPlayerControls(controller: controller) : null,
            showControls: options?.mode == SSVideoPlayerMode.community ? true : options?.enableControls ?? true
          )
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );
    if (options?.mode == SSVideoPlayerMode.community) {
      // _switchSound(FeedViewController.areVideosMuted);
    }

  }

  @override
  DownloadUrlData get downloadUrlData {
    return DownloadUrlData(uniquePrefix: id.toString(), url: videoUrl);
  }
  void _switchSound(bool muted) {
    betterPlayerController?.setVolume(muted ? 0 : 1);
  }

}