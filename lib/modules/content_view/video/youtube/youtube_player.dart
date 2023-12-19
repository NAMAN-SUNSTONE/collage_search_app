import 'package:admin_hub_app/modules/content_view/video/youtube/youtube_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:hub/academic_content/content_view/video/youtube/youtube_player_controller.dart';
// import 'package:hub/constants/enums.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../constants/enums.dart';
import '../../../../widgets/ss_loader.dart';

class SSYoutubePlayer extends StatelessWidget {
  const SSYoutubePlayer({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SSYoutubePlayerController>(
        init: SSYoutubePlayerController(videoUrl: videoUrl),
        tag: key.toString(),
        builder: (controller) {
          if (videoUrl.isEmpty) {
            return SSLoader.light(child: SizedBox.shrink(), status: Status.error,);
          }
          return YoutubePlayerScaffold(
            controller: controller.ytController,
            builder: (context, child){
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
              return child;
            },
          );
        });
  }
}
