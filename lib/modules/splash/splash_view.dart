import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  static const _topGradientColor = Color(0xFF3B569E);

  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.theme.colorScheme.primary;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_topGradientColor, primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.2, 0.95],
              ),
            ),
            // color: primaryColor,
            child: SafeArea(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Lottie.asset(Assets.lottieSsSunstoneFadeIn,
                      height: 50, frameRate: FrameRate.max)),
            ),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: Lottie.asset(Assets.lottieSsFullScreenLoader,
                fit: BoxFit.cover,
                controller: controller.backgroundAnimationController,
                repeat: false, onLoaded: (composition) {
              controller.backgroundAnimationController
                ..duration = composition.duration
                ..forward()
                    .whenComplete(() => controller.onAnimationComplete());
            }, frameRate: FrameRate.max),
          )
        ],
      ),
    );
  }
}
