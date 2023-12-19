package com.sunstone.admin
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
       MoEngageUtils.initialize(this);
    }
}