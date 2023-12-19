import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';
// import 'package:hub/theme/colors.dart';

class ThreeDotMenuController {
  late Widget child;
  ThreeDotMenuController(this.child);

  OverlayEntry? overlayEntry;

  // Remove the OverlayEntry.
  void close() {
    if (overlayEntry == null) return;
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void onTap(context) {
    if (overlayEntry != null) {
      // Remove the existing OverlayEntry.
      return close();
    }

    overlayEntry = OverlayEntry(
      // Create a new OverlayEntry.
      builder: (BuildContext context) {
        // Align is used to position the highlight overlay
        // relative to the NavigationBar destination.
        return GestureDetector(
          onTap: close,
          child: Container(
            color: Colors.transparent,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 56, right: 4),
                child: Align(
                    alignment: Alignment.topRight,
                    heightFactor: 1.0,
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:  const BorderSide(
                            color:HubColor.dividerColorEF, width: 1),
                      ),
                      color: HubColor.white,
                      child: child,
                    )),
              ),
            ),
          ),
        );
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context).insert(overlayEntry!);
  }
}

class ThreeDotMenu extends StatelessWidget {
  final ThreeDotMenuController controller;
  const ThreeDotMenu(
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => controller.onTap(context),
        icon: Icon(
          Icons.more_vert_outlined,
          color: HubColor.grey1,
        ));
  }
}
