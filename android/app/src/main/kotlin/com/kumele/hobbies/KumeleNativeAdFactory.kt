package com.kumele.hobbies

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.LayoutInflater
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory

/**
 * Renders AdMob native ads with the same card look as Kumele's existing
 * first-party ad cards (see ExploreFeedAdCard in explore_discount.dart and
 * the notification ad tile in notification_list_view.dart), instead of
 * Google's generic native ad template. Both the Local Events and
 * Notifications placements share this layout/factory; only the ad content
 * and the container size (set on the Flutter side) differ between them.
 *
 * Colors mirror lib/shared/components/app_colors.dart's bg2Color/textColor/
 * subTextColor. Dart passes "isDark" through NativeAd.customOptions so this
 * matches the app's current theme (Kumele's theme toggle is manual, not
 * system-driven, so a resource qualifier like values-night can't track it).
 */
class KumeleNativeAdFactory(private val context: Context) : NativeAdFactory {

    private object LightColors {
        val CARD_BG = Color.WHITE
        val HEADLINE = Color.BLACK
        val BODY = Color.parseColor("#9B9999")
    }

    private object DarkColors {
        val CARD_BG = Color.BLACK
        val HEADLINE = Color.WHITE
        val BODY = Color.parseColor("#9B9999")
    }

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?,
    ): NativeAdView {
        val isDark = customOptions?.get("isDark") == true
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_local_events, null) as NativeAdView

        val cardBackground = if (isDark) DarkColors.CARD_BG else LightColors.CARD_BG
        val headlineColor = if (isDark) DarkColors.HEADLINE else LightColors.HEADLINE
        val bodyColor = if (isDark) DarkColors.BODY else LightColors.BODY

        val card = adView.findViewById<android.widget.LinearLayout>(R.id.ad_card)
        card.background = GradientDrawable().apply {
            setColor(cardBackground)
            cornerRadius = context.resources.displayMetrics.density * 12
        }
        card.clipToOutline = true

        val badge = adView.findViewById<TextView>(R.id.ad_badge)
        badge.background = GradientDrawable().apply {
            setColor(Color.parseColor("#B3000000"))
            cornerRadius = context.resources.displayMetrics.density * 4
        }

        val headline = adView.findViewById<TextView>(R.id.ad_headline)
        headline.text = nativeAd.headline
        headline.setTextColor(headlineColor)
        adView.headlineView = headline

        val body = adView.findViewById<TextView>(R.id.ad_body)
        val bodyText = nativeAd.body
        if (bodyText.isNullOrEmpty()) {
            body.visibility = android.view.View.GONE
        } else {
            body.visibility = android.view.View.VISIBLE
            body.text = bodyText
            body.setTextColor(bodyColor)
        }
        adView.bodyView = body

        val mediaView = adView.findViewById<com.google.android.gms.ads.nativead.MediaView>(
            R.id.ad_media,
        )
        adView.mediaView = mediaView
        nativeAd.mediaContent?.let { mediaView.mediaContent = it }

        adView.setNativeAd(nativeAd)
        return adView
    }
}
