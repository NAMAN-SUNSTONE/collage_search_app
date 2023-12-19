import 'dart:async';
import 'dart:convert';
import 'package:admin_hub_app/analytics/events/screen_mapper.dart';
import 'package:admin_hub_app/analytics/utils/moengage.dart';
import 'package:flutter/cupertino.dart';

///Abstract class to be inherited that contains all the properties required to create an analytic event
abstract class AnalyticEvents with AnalyticsScreenMapper {
  late String _currentPageName;

  //must be called initially inside every event
  _initVariables() {
    _currentPageName = getCurrentScreenName();
  }

  sendEvent(String eventName, {String? pageName, Map<String, dynamic>? data}) {
    try {
      _initVariables();
      if (data == null) data = <String, dynamic>{};
      data['screen_name'] = pageName ?? _currentPageName;
      debugPrint("Event trigger : $eventName");
      debugPrint("With data : ${data.toString()}");
      MoEngageUtils.sendEvent(eventName, data);
    } catch (e) {
      debugPrint('unable to send event : $eventName');
    }
  }

  sendEventWithoutPageName(String eventName, {Map<String, dynamic>? data}) {
    try {
      MoEngageUtils.sendEvent(eventName, data);
    } catch (e) {
      debugPrint('unable to send event : $eventName');
    }
  }
}
