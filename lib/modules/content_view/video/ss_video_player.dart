import 'package:admin_hub_app/modules/content_view/video/ss_video_player_mobile.dart';
import 'package:flutter/material.dart';
// import 'package:hub/academic_content/content_view/video/ss_video_player_mobile.dart';
// import 'package:hub/academic_content/content_view/video/ss_video_player_web.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/multiplatform.dart';
// import 'package:hub/sunstone_base/utils/multiplatform/ss_platform.dart';
import 'package:sunstone_ui_kit/typo/ui_kit_default_typo.dart';

import 'youtube/youtube_player.dart';

class SSVideoPlayerOptions {

  const SSVideoPlayerOptions({required this.loop, required this.enableControls, required this.mode});

  final bool loop;
  final bool enableControls;
  final SSVideoPlayerMode mode;

}

enum SSVideoPlayerMode { lms, community }

class SSVideoPlayer extends StatelessWidget {
  final String url;
  final String? title;
  final SSVideoPlayerOptions? options;
  final int? id;

  const SSVideoPlayer({Key? key, required this.url, this.title, this.options, this.id})
      : super(key: key);

  bool get isYoutubeVideo {
    debugPrint(Uri.parse(url).host);
    return Uri.parse(url).host == 'www.youtube.com';
  }

  bool get isMobile {
    return true;
    // return getPlatform() == SSPlatform.ios ||
    //     getPlatform() == SSPlatform.android;
  }

  bool get isWeb => /*getPlatform() == SSPlatform.web*/ false;

  Widget _getPlayer() {
    if (isYoutubeVideo) {
      return SSYoutubePlayer(videoUrl: url, key: key,);
    }

    // if (isMobile) {
      return SSVideoPlayerMobile(videoUrl: url, key: key, options: options, id: id,);
    // } else if (isWeb) {
    //   return SSVideoPlayerWeb(
    //     url: url,
    //     key: key,
    //   );
    // } else {
    //   return Center(child: Text("Unsupported Platform"));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          if (title != null )

          Center(child: _getPlayer()),
        ],
      ),
    );
  }
}
