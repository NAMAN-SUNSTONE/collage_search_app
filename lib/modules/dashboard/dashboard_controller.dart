import 'package:admin_hub_app/base/base_controller.dart';
import 'package:admin_hub_app/modules/offline/offline_utils.dart';
import 'package:admin_hub_app/modules/schedule/schedule_view.dart';
import 'package:admin_hub_app/modules/subjects/ui/subject_view_new.dart';
import 'package:admin_hub_app/modules/timetable/timetable_view.dart';
import 'package:admin_hub_app/remote_config/app_feature.dart';
import 'package:admin_hub_app/remote_config/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends BaseController {

  RemoteConfig _remoteConfig = Get.find<RemoteConfig>();

  List<AppFeature> get features => _remoteConfig.featureList;
  List<Widget> get pages => _generatePages(features);
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    OfflineUtils.sync();
  }

  List<Widget> _generatePages(List<AppFeature> features) {
    List<Widget> pages = [];

    features.forEach((feature) {

      switch (feature) {
        case AppFeature.timetable:
          pages.add(TimetableView());
          break;
        case AppFeature.subjects:
          pages.add(SubjectsViewNew());
          break;
      }

    });

    return pages;
  }

  void onTabChange(int index) => currentIndex.value = index;

}