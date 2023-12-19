import 'package:admin_hub_app/modules/content_view/video/ss_video_player.dart';
import 'package:admin_hub_app/modules/content_view/video/ss_video_player_controller_mobile.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:hub/academic_content/content_view/video/ss_video_player.dart';
// import 'package:hub/academic_content/content_view/video/ss_video_player_controller_mobile.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SSVideoPlayerMobile extends GetView<SSVideoPlayerControllerMobile> {
  final String videoUrl;
  final int? id;
  final SSVideoPlayerOptions? options;

  SSVideoPlayerMobile({Key? key, required this.videoUrl, this.options, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SSVideoPlayerControllerMobile>(
        init: SSVideoPlayerControllerMobile(
            videoUrl: videoUrl, options: options, id: id),
        tag: key.toString(),
        global: false,
        builder: (controller) {
          return WillPopScope(
            onWillPop: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              return Future.value(true);
            },
            child: Obx(() {
              if(controller.shouldRenderPlayer.value)
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: VisibilityDetector(
                  key: GlobalKey(),
                  onVisibilityChanged: (details) {},
                  child: BetterPlayer(
                    controller: controller.betterPlayerController!,
                    key: Key(key.toString() + 'bp'),
                  ),
                ),
              );

              return SizedBox.shrink();
            }),
          );
        });
  }
}
