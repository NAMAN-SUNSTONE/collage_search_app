import 'package:admin_hub_app/constants/enums.dart';
import 'package:flutter/services.dart';

abstract class FlavourValueKeys {
  static const String baseUrl = 'baseUrl';
  static const String baseUrlWeb = 'baseUrlWeb';
  static const String baseUrlMiscellaneous = 'baseUrlMiscellaneous';
  static const String baseUrlStudentApi = 'baseUrlStudentApi';
  static const String flavorName = 'flavorName';
  static const String cashFreeStage = 'cashfreeStage';
  static const String platform = 'platform';
}

abstract class MethodChannels {
  static const defaultChannel = MethodChannel('com.sunstone.admin');
}

abstract class UIConstants {
  static final double eventBannerAspectRatio = 16 / 9;
  static final double communityBannerAspectRatio = 21 / 9;
}
