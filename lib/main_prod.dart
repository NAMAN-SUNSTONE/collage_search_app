import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/main.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'constants/constants.dart';

void flavorConfigProd() {
  FlavorConfig(
    name: "prod",
    variables: {
      FlavourValueKeys.baseUrl: "https://hub-console-api.sunstone.in/",
      FlavourValueKeys.baseUrlWeb: "https://hub.sunstone.in/",
      FlavourValueKeys.baseUrlMiscellaneous: "https://miscellanous.sunstone.in/",
      FlavourValueKeys.baseUrlStudentApi: "https://student-api.sunstone.in/",
      FlavourValueKeys.flavorName: AppFlavors.prod,
      FlavourValueKeys.cashFreeStage: "PROD"
    },
  );
}

void main() async {
  flavorConfigProd();
  //Calling our Main Main method.
  commonMain();
}
