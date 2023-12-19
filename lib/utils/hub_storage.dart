import 'package:admin_hub_app/constants/enums.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HubStorage {
  static const _boxName = 'admin_storage';
  static const _adminApp = 'admin_app';

  static HubStorage? _instance;

  late Box _storeBox;

  HubStorage._internal();

  static HubStorage getInstance() {
    _instance ??= HubStorage._internal();
    return _instance!;
  }

  Future init() async {
    await Hive.initFlutter(_adminApp);
    _storeBox = await Hive.openBox(_boxName);
  }

  AppFlavors get flavor => AppFlavors.values.byName(_storeBox.get(HubStoreKey.flavor.toString()));

  set flavor(AppFlavors flavor) {
    _storeBox.put(HubStoreKey.flavor.toString(), flavor.name);
  }

  String? get userId => _storeBox.get(HubStoreKey.userId.toString());

  set userId(String? value) {
    _storeBox.put(HubStoreKey.userId.toString(), value);
  }

  String? get authToken => _storeBox.get(HubStoreKey.authToken.toString());

  set authToken(String? value) {
    _storeBox.put(HubStoreKey.authToken.toString(), value);
  }

  String? get email => _storeBox.get(HubStoreKey.email.toString());

  set email(String? value) {
    _storeBox.put(HubStoreKey.email.toString(), value);
  }

  String? get phone => _storeBox.get(HubStoreKey.phone.toString());

  set phone(String? value) {
    _storeBox.put(HubStoreKey.phone.toString(), value);
  }

  Future<bool> dumpStorage() async {
    await _storeBox.clear();
    return true;
  }

  static Map<String, dynamic> getUserData() {
    return {
      "id": HubStorage.getInstance().userId.toString(),
      "session_key": HubStorage.getInstance().authToken,
      "email": HubStorage.getInstance().email,
      "phone": HubStorage.getInstance().phone,
    };
  }
}

enum HubStoreKey { authToken, fcmToken, email, phone, userId, flavor }
