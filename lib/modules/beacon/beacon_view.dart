import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/theme/size.dart';
import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:admin_hub_app/modules/beacon/beacon_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class BeaconView extends GetView<BeaconController> {
  const BeaconView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: controller.onPop,
        child: Scaffold(
          body: Obx(() => _getScreen(controller.status.value)),
        ));
  }

  Widget _getScreen(Status status) {
    //return _LoadingScreen();
    switch (status) {
      case Status.success:
        return _BroadCasting();
      case Status.error:
        return _Failed();
      case Status.loading:
        return _LoadingScreen();
      default:
        return _BroadCasting();
    }
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          Lottie.asset(
            Assets.lottieCountdown,
          ),
          Column(children: [
            Text(
              "Hang Tight!",
              style: context.textTheme.headline3!.copyWith(
                  color: HubColor.primary,
                  fontWeight: FontWeight.w400,
                  fontSize: 26),
            ),
            Space(
              factor: 2,
            ),
            Text(
              "We’re preparing the attendance log",
              style: UIKitDefaultTypography().bodyText2.copyWith(
                  color: HubColor.grey1.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            Space(
              factor: 8,
            ),
          ])
        ],
      ),
    );
  }
}

class _Failed extends GetView<BeaconController> {
  const _Failed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              SvgPicture.asset(Assets.svgFailed),
              Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      Text(
                        "Something went wrong",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: HubColor.yellow2,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      const Space(
                        factor: 4,
                      ),
                      Text(
                        "• Make sure bluetooth is on \n\n• Try Reconnecting Wi-Fi/ Internet",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: HubColor.grey1.withOpacity(0.3)),
                      ),
                      const Space(factor: 4),
                    ],
                  ))
            ],
          ),
        ),
        Container(
            height: 48,
            width: double.infinity,
            margin: Sizes.margin,
            child: UIKitFilledButton(
                text: "Retry", onPressed: controller.onRetry)),
      ],
    );
  }
}

class _BroadCasting extends GetView<BeaconController> {
  const _BroadCasting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 70),
                      ClassTag(
                        controller.event,
                        showBackground: true,
                      ),
                      Space(),
                      Text(
                        controller.event.displayTitle,
                        style: context.textTheme.bodyText1?.copyWith(
                          color: HubColor.grey6,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(Assets.lottieSearching),
                      Lottie.asset(Assets.lottieSsLoaderBlue, width: 80),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        children: [
                          Text("Capturing Attendance",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      fontSize: 24, color: HubColor.primary)),
                          const Space(
                            factor: 3,
                          ),
                          Text(
                            "• Don’t refresh your app",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    color: HubColor.grey1.withOpacity(0.3)),
                          ),
                          const Space(),
                          Text(
                            "• Make sure your bluetooth is on",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    color: HubColor.grey1.withOpacity(0.3)),
                          ),
                          const Space(factor: 4),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
        //BottomButton(onTap: controller.onDone)
        Container(
            height: 48,
            width: double.infinity,
            margin: Sizes.margin,
            child: UIKitFilledButton(
                text: "Stop Capturing", onPressed: controller.onDone)),
      ],
    );
  }
}
