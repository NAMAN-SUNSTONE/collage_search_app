import 'package:admin_hub_app/constants/constants.dart';
import 'package:admin_hub_app/constants/enums.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

abstract class FlavourVariables {
  static String baseHubURL = '';
  static String webBaseUrl = '';
  static String baseMiscellanousURL = '';
  static String baseStudentURL = '';
  static AppFlavors flavorName = AppFlavors.dev;
  static String cashfreeStage = '';

  static Future init() async {
    baseHubURL =  FlavorConfig.instance.variables[FlavourValueKeys.baseUrl];
    webBaseUrl =  FlavorConfig.instance.variables[FlavourValueKeys.baseUrlWeb];
    baseMiscellanousURL =  FlavorConfig.instance.variables[FlavourValueKeys.baseUrlMiscellaneous];
    baseStudentURL =  FlavorConfig.instance.variables[FlavourValueKeys.baseUrlStudentApi];
    flavorName = FlavorConfig.instance.variables[FlavourValueKeys.flavorName];
    cashfreeStage = FlavorConfig.instance.variables[FlavourValueKeys.cashFreeStage];
  }
}
