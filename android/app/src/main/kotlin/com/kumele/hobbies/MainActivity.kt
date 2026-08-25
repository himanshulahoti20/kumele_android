package com.kumele.hobbies

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

private const val LOCAL_EVENTS_AD_FACTORY_ID = "localEventsAdFactory"
private const val NOTIFICATIONS_AD_FACTORY_ID = "notificationsAdFactory"

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val adFactory = KumeleNativeAdFactory(this)
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            LOCAL_EVENTS_AD_FACTORY_ID,
            adFactory,
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            NOTIFICATIONS_AD_FACTORY_ID,
            adFactory,
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, LOCAL_EVENTS_AD_FACTORY_ID)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, NOTIFICATIONS_AD_FACTORY_ID)
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
