import 'dart:developer';

import 'package:admin_hub_app/modules/beacon/utils/uuid.dart';
import 'package:admin_hub_app/modules/content_view/lecture_model.dart';
import 'package:admin_hub_app/modules/schedule/model/event_model.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/utils/native_bridge.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:admin_hub_app/base/base_controller.dart';

class BeaconArguments {
  late final LectureEventListModel event;
  late final void Function() onRefresh;

  BeaconArguments({required this.event, required this.onRefresh});
}

class BeaconController extends BaseController {
  late final LectureEventListModel event;
  late final BeaconArguments arguments;
  final BeaconBroadcast _beaconBroadcast = BeaconBroadcast();
  String _uuid = '';

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments is! BeaconArguments) {
      failed();
      return;
    } else {
      success();
    }
    arguments = Get.arguments as BeaconArguments;
    event = arguments.event;
    generateUUID();
    startBroadCast();
  }

  generateUUID() {
    _uuid = UUIDUtils.encode(UUIDParams(
        classId: (event.lectureMapId ?? event.id).toString(),
        lectureDate: event.lectureDate!,
        lectureStartTime: event.lectureStartTime!));
    _uuid = UUIDUtils.format(_uuid);
  }

  startBroadCast() async {
    await _checkPermission();
    BeaconStatus transmissionSupportStatus =
        await _beaconBroadcast.checkTransmissionSupported();

    if (transmissionSupportStatus != BeaconStatus.supported) {
      return failed();
    } else {
      success();
    }

    debugPrint('broadcasting uuid');
    debugPrint(_uuid);
    await _beaconBroadcast
        .setIdentifier("com.sunstone.admin")
        .setUUID(_uuid)
        .setTransmissionPower(-1)
        .setAdvertiseMode(AdvertiseMode.lowLatency)
        .setMajorId(0)
        .setMinorId(0)
        .start();
  }

  onRetry() => startBroadCast();

  @override
  dispose() {
    super.dispose();
    stopBroadCasting();
  }

  Future<bool> onPop() async {
    stopBroadCasting();
    return true;
  }

  stopBroadCasting() {
    _beaconBroadcast.stop();
  }

  _checkPermission() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothAdvertise.request();
    await NativeBridge.enableBluetooth();
  }

  Future isBroadCasting() async => await _beaconBroadcast.isAdvertising();

  onDone() async {
    loading();
    stopBroadCasting();
    await Future.delayed(Duration(seconds: 3));
    Get.until((route) => route.isFirst);
    //Get.offNamedUntil(Paths.attendanceReport, (route) => route.isFirst,arguments: event)
    //Get.offNamed(Paths.attendanceReport, arguments: event)
    Get.toNamed(Paths.attendanceReport, arguments: event)
        ?.then((value) => arguments.onRefresh());
    ;
  }
}
