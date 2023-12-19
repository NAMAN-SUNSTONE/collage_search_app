import 'package:get/get.dart';
import 'package:admin_hub_app/modules/beacon/beacon_controller.dart';

class BeaconBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeaconController>(() => BeaconController(), fenix: true);
  }
}
