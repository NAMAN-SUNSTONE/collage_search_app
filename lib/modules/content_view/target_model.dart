// import 'package:hub/constants/enums.dart';

//caution: do not update this enum
import '../../constants/enums.dart';

enum Identifiers {
  video,
  pdf,
  web_view,
  web_view_auth,
  custom_web_view,
  native_custom_webview,
  browser,
  fresh_desk,
  open_deeplink,
  download,
  login,
  zoom_meeting,
  wistia,
  wistia_video
}

class Target {
  Target({
    required this.identifier,
    required this.value,
    required this.title,
    this.isLoginRequired = false,
    required this.redirectUrl,
    this.onLogin
  });

  late final Identifiers identifier;
  late final String value;
  late final String title;
  late final bool isLoginRequired;
  late final String redirectUrl;
  late final Function? onLogin;
  late final Map<String, dynamic> data;

  Target.fromJson(Map<String, dynamic> json) {
    identifier = enumFromString(Identifiers.values, json['identifier']) ??
        Identifiers.open_deeplink;
    value = json['value'] ?? "";
    isLoginRequired = json['is_login_required'] ?? false;
    title = json['title'] ?? "";
    redirectUrl = json['redirect_url'] ?? "";
    data = json['data'] ?? {};
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['identifier'] = identifier.toString().split('.').last;
    _data['value'] = value;
    _data['title'] = title;
    _data['is_login_required'] = isLoginRequired;
    _data['redirect_url'] = redirectUrl;
    _data['data'] = data;
    return _data;
  }
}
