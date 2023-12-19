import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'constants/constants.dart';

void flavorConfigDev() {
  FlavorConfig(
    name: "dev",
    color: Colors.red,
    location: BannerLocation.topStart,
    variables: {
      FlavourValueKeys.baseUrl: "https://dev-hub-console-api.sunstone.in/",
      FlavourValueKeys.baseUrlWeb: "https://dev-hub.sunstone.in/",
      FlavourValueKeys.baseUrlMiscellaneous:
      "https://dev-miscellanous.sunstone.in/",
      FlavourValueKeys.baseUrlStudentApi:
      "https://dev-student-api.sunstone.in/",
      FlavourValueKeys.flavorName: AppFlavors.dev,
      FlavourValueKeys.cashFreeStage: "TEST"
    },
  );
}

void main() async {
  flavorConfigDev();
  //Calling our Main method.
  commonMain();
}
