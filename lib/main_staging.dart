import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'constants/constants.dart';

void flavorConfigStaging() {
  FlavorConfig(
    name: "staging",
    color: Colors.purple,
    location: BannerLocation.topEnd,
    variables: {
      FlavourValueKeys.baseUrl: "https://staging-hub-console-api.sunstone.in/",
      FlavourValueKeys.baseUrlWeb: "https://staging-hub.sunstone.in/",
      FlavourValueKeys.baseUrlMiscellaneous:
      "https://staging-miscellanous.sunstone.in/",
      FlavourValueKeys.baseUrlStudentApi:
      "https://staging-student-api.sunstone.in/",
      FlavourValueKeys.flavorName: AppFlavors.staging,
      FlavourValueKeys.cashFreeStage: "PROD"
    },
  );
}
void main() async {
  flavorConfigStaging();
  //Calling our Main Main method.
  commonMain();
}
