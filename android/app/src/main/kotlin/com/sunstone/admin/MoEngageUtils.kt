package com.sunstone.admin

import android.app.Application
import com.moengage.core.DataCenter
import com.moengage.core.MoEngage
import com.moengage.core.config.FcmConfig
import com.moengage.core.config.InAppConfig
import com.moengage.core.config.NotificationConfig
import com.moengage.core.config.PushKitConfig
import com.moengage.core.model.SdkState
import com.moengage.flutter.MoEInitializer

class MoEngageUtils {

    companion object {

        fun initialize(application: Application) {

            val moEngage = MoEngage.Builder(application, "Q83YHT7HD3405NZ65BEM8LHO")
                .setDataCenter(DataCenter.DATA_CENTER_3)
                .configureNotificationMetaData(
                    NotificationConfig(
                        R.drawable.ic_launcher_foreground, R.mipmap.launcher_icon,
                        -1,
                        isMultipleNotificationInDrawerEnabled = true,
                        isBuildingBackStackEnabled = false,
                        isLargeIconDisplayEnabled = true
                    )
                )
                .configureFcm(FcmConfig(true))
                .configurePushKit(PushKitConfig(true))
                .configureInApps(InAppConfig.defaultConfig())


            MoEInitializer.initialiseDefaultInstance(application, moEngage, SdkState.ENABLED)

        }

    }

}