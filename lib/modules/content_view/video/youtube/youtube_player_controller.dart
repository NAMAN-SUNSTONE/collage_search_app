import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../base/base_controller.dart';
// import 'package:hub/academic_content/content_view/content_view_controller.dart';
// import 'package:hub/ui/base_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../content_view_controller.dart';

class SSYoutubePlayerController extends BaseController {
  final String videoUrl;

  SSYoutubePlayerController({required this.videoUrl});

  late YoutubePlayerController ytController;

  @override
  void onInit() {
    super.onInit();
    Get.find<ContentViewController>().fullScreenOnRotate = true;
    _setupController();
  }

  @override
  void onClose() {
    ytController.playerState.then((value) {
      ytController.close();
    });

    Get.find<ContentViewController>().fullScreenOnRotate = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  }

  String? _extractIdFromLink(String? url) {
    if (url == null) return null;
    final youtubeId = url.split('=').last;
    return youtubeId;
  }

  _setupController() async {
    final String? videoId = _extractIdFromLink(videoUrl);
    ytController = YoutubePlayerController.fromVideoId(
      videoId: videoId!,
      autoPlay: true,
      params: YoutubePlayerParams(
        showFullscreenButton: true
      )
    );

    }

}
