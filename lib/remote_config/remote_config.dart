import 'dart:convert';

import 'package:admin_hub_app/remote_config/app_feature.dart';
import 'package:admin_hub_app/remote_config/remote_config_keys.dart';
import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfig {

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialise() async {
    try {
      await _setupConfig();
      await _fetchFromFirebase();
    } catch (e) {
      debugPrint('RemoteConfig => ${e.toString()}');
      _fetchFromCache();
    }
  }

  Future<void> _setupConfig() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval: Duration.zero),
      );
    } catch (e) {
      debugPrint('RemoteConfig => ${e.toString()}');
    }
  }

  Future<void> _fetchFromFirebase() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint('RemoteConfig => ${e.toString()}');
    }
  }

  Future<void> _fetchFromCache() async {
    try {
      await _remoteConfig.activate();
    } catch (e) {
      debugPrint('RemoteConfig => ${e.toString()}');
    }
  }

  List<AppFeature> get featureList {
    List<AppFeature> list = [];

    String data = _remoteConfig.getValue(RemoteConfigKeys.enabledFeatures).asString();
    if (data.isNotNull) {
      dynamic json = jsonDecode(data);
      if (json is List) {
        json.forEach((element) {
          list.add(AppFeature.values.byName(element));
        });
      }
    }

    return list;
  }

}