// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/sunstone_base/nudge/user_manager.dart';
//
// class LmsMiddleware extends GetMiddleware {
//   @override
//   RouteSettings? redirect(String? route) {
//     final userNudgeData =  UserManager.nudge.value;
//     if (userNudgeData.isLmsEnabled) {
//       return super.redirect(route);
//     } else {
//       return RouteSettings(name: Paths.subjectViewNew);
//     }
//   }
// }
