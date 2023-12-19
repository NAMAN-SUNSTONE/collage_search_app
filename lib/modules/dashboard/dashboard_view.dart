import 'package:admin_hub_app/generated/assets.dart';
import 'package:admin_hub_app/modules/dashboard/dashboard_controller.dart';
import 'package:admin_hub_app/remote_config/app_feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.pages.isNotEmpty) {
          return controller.pages[controller.currentIndex.value];
        } else {
          return SizedBox();
        }
      }),
      bottomNavigationBar: controller.features.length >= 2
          ? Obx(
              () {
            return DashboardNavigationBar(
                features: controller.features,
                selectedFeatureTab: controller.features[controller.currentIndex
                    .value],
                onTap: controller.onTabChange);
          }
      )
          : null,
    );
  }
}

class DashboardNavigationBar extends StatelessWidget {
  const DashboardNavigationBar({required this.features,
    required this.selectedFeatureTab,
    required this.onTap});

  final List<AppFeature> features;
  final AppFeature selectedFeatureTab;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) =>
      BottomNavigationBar(
          currentIndex: features.indexOf(selectedFeatureTab),
          items: features
              .map((feature) =>
              DashboardNavigationBarItem(
                  feature: feature, isSelected: feature == selectedFeatureTab))
              .toList(),
          onTap: onTap);
}

class DashboardNavigationBarItem extends BottomNavigationBarItem {
  DashboardNavigationBarItem({required this.feature, required this.isSelected})
      : super(icon: _getIcon(feature, isSelected), label: _getLabel(feature));

  final AppFeature feature;
  final bool isSelected;

  static Widget _getIcon(AppFeature feature, bool isSelected) {
    switch (feature) {
      case AppFeature.timetable:
        return SvgPicture.asset(
            isSelected ? Assets.svgTabTimetableActive : Assets
                .svgTabTimetableInactive);
      case AppFeature.subjects:
        return SvgPicture.asset(
            isSelected ? Assets.svgTabSubjectsActive : Assets
                .svgTabSubjectsInactive);
    }
  }

  static String _getLabel(AppFeature feature) {
    switch (feature) {
      case AppFeature.timetable:
        return 'My Timetable';
      case AppFeature.subjects:
        return 'My Subjects';
    }
  }
}
