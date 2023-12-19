import 'package:get/get.dart';

extension GetExtension on GetInterface {
  String get currentRouteWithoutParams {
    String getRoute = this.currentRoute;
    Uri uri = Uri.parse(getRoute);
    return uri.path;
  }
}
