import 'package:moengage_flutter/moengage_flutter.dart';

/// MoEngage helper class
/// use only this to communicate with [MoEngage] plugin
class MoEngageUtils {
  static const _appId = 'Q83YHT7HD3405NZ65BEM8LHO';
  static late MoEngageFlutter _moEngagePlugin;

  static void initialise() {
    _moEngagePlugin = MoEngageFlutter(_appId);
    _moEngagePlugin.initialise();
    _moEngagePlugin.configureLogs(LogLevel.DEBUG);
    _moEngagePlugin.requestPushPermissionAndroid();
    _moEngagePlugin.registerForPushNotification();

    return;
  }

  static void setProfile(String userId, String email, String phone) {
    _moEngagePlugin.setUniqueId(userId);
    _moEngagePlugin.setEmail(email);
    _moEngagePlugin.setPhoneNumber(phone);
  }

  static sendEvent(String eventName, [Map<String, dynamic>? data]) {
    final MoEProperties? properties = _parseProperties(data);
    _moEngagePlugin.trackEvent(eventName, properties);
  }

  ///parses the data [Map] into [MoEProperties]
  static MoEProperties? _parseProperties(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return null;
    MoEProperties moProperties = MoEProperties();
    data.forEach((key, value) {
      moProperties.addAttribute(key, value);
    });
    return moProperties;
  }

  static void logout() => _moEngagePlugin.logout();
}
