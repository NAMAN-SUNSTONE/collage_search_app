import 'dart:async';
import 'dart:ui';

import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/initialisation.dart';
import 'package:admin_hub_app/main_dev.dart';
import 'package:admin_hub_app/main_prod.dart';
import 'package:admin_hub_app/main_staging.dart';
import 'package:admin_hub_app/modules/offline/offline_utils.dart';
import 'package:admin_hub_app/routes/app_pages.dart';
import 'package:admin_hub_app/theme/colors.dart';
import 'package:admin_hub_app/theme/theme.dart';
import 'package:admin_hub_app/utils/connectivity_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

import 'constants/constants.dart';

void commonMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialiseApp();
  await initializeService();
  AppFlavors flavor =
      FlavorConfig.instance.variables[FlavourValueKeys.flavorName];
  runApp(flavor == AppFlavors.prod
      ? const MyApp()
      : FlavorBanner(child: const MyApp()));
}

// this will be used as notification channel id
const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'Smart Sync',
    description:
        'This channel is used to display ongoing Smart Sync service.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: 'Smart Sync',
        initialNotificationContent: 'Smart sync will ensure a smooth attendance flow in low network areas',
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration());
}

Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  Timer.periodic(const Duration(minutes: 15), (timer) async {

    AppFlavors flavor = AppFlavors.dev;
    switch (flavor) {
      case AppFlavors.dev:
        flavorConfigDev();
        break;
      case AppFlavors.prod:
        flavorConfigProd();
        break;
      case AppFlavors.staging:
        flavorConfigStaging();
        break;
    }
    await initialiseApp();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        debugPrint('Offline service running...');
        OfflineUtils.sync();
      }
    }
  });
}

class MyAppState extends State<MyApp> {

  bool? isOnline;
  bool syncing = false;

  @override
  void initState() {
    ConnectivityManager.isOnline().then((value) {
      setState(() {
        isOnline = value;
      });
    });
    OfflineUtils.syncingStreamController.stream.listen((event) {
      setState(() {
        syncing = event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIKitApp(
        uiTheme: UIKitTheme(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            appBar: isOnline == false || syncing ? PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                padding: EdgeInsets.all(4),
                color: HubColor.greenDark,
                child: Center(
                  child: Text(syncing ? 'Syncing' : 'Offline mode', style: UIKitDefaultTypography().caption.copyWith(color: HubColor.white)),
                ),
              ),
            ) : null,
            body: GetMaterialApp(
              theme: hubTheme,
              title: "Student Hub",
              getPages: AppPages.routes,
              initialRoute: AppPages.initial,
              locale: const Locale('en', 'US'),
              fallbackLocale: const Locale('en', 'US'),
              debugShowCheckedModeBanner: kDebugMode,
            ),
          ),
        ));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}
