import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
// import 'package:hub/community/ui/feed/feed_controller.dart';

class SSPlayerControls extends StatefulWidget {
  const SSPlayerControls({required this.controller});

  final BetterPlayerController controller;

  @override
  _SSPlayerControlState createState() => _SSPlayerControlState();
}

class _SSPlayerControlState extends State<SSPlayerControls> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8),
        //     child: CircleAvatar(
        //       radius: 14,
        //       backgroundColor: Colors.black.withOpacity(.7),
        //       child: IconButton(
        //         padding: EdgeInsets.zero,
        //         onPressed: () {
        //           if (FeedViewController.areVideosMuted) {
        //             widget.controller.setVolume(1);
        //           } else {
        //             widget.controller.setVolume(0);
        //           }
        //           setState(() {
        //             FeedViewController.areVideosMuted = !FeedViewController.areVideosMuted;
        //           });
        //         },
        //         icon: Icon(
        //           FeedViewController.areVideosMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
        //           size: 16,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
