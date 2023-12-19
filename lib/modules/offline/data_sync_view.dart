import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/modules/offline/data_sync_controller.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sunstone_ui_kit/ui_kit.dart';

class DataSyncView extends GetView {
  @override
  Widget build(BuildContext context) => GetBuilder(
      init: DataSyncController(),
      global: false,
      builder: (DataSyncController controller) => Scaffold(
            appBar: SHAppBar(title: 'Sync+'),
            // body: Obx(() => Container(
            //   child: Center(
            //     child: controller.status.value == Status.loading ? CircularProgressIndicator() : SizedBox()
            //   ),
            // )),
            bottomNavigationBar: Obx(() => Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: UIKitOutlineButton(
                        text: 'Check Status',
                        isEnabled: controller.buttonsEnabled.value,
                        onPressed: controller.onDownloadClick),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: UIKitFilledButton(
                        text: 'Start Sync',
                        isEnabled: controller.buttonsEnabled.value,
                        onPressed: controller.onUploadClick),
                  ),
                ],
              ),
            ),
            ),
          ));
}
