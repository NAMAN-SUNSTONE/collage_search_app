import 'package:admin_hub_app/db/db_helper.dart';
import 'package:admin_hub_app/remote_config/remote_config.dart';
import 'package:admin_hub_app/utils/build_info.dart';
import 'package:admin_hub_app/utils/cloud_messaging.dart';
import 'package:admin_hub_app/utils/flavour_variables.dart';
import 'package:admin_hub_app/utils/hub_storage.dart';
import 'package:admin_hub_app/analytics/utils/moengage.dart';
import 'package:admin_hub_app/utils/setup_get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'deep_links/deep_links.dart';

Future initialiseApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlavourVariables.init();
  await Firebase.initializeApp();
  await setupGet();
  await HubStorage.getInstance().init();
  // HubStorage.getInstance().flavor = FlavourVariables.flavorName;
  await BuildInfo.init();
  RemoteConfig remoteConfig = Get.find<RemoteConfig>();
  await remoteConfig.initialise();
  await CloudMessaging.requestPermission();
  MoEngageUtils.initialise();
  await DeepLinks.getInstance().init();
  await DatabaseHelper.setup();
}
