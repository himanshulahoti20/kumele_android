import 'package:flutter/foundation.dart';

/// AdMob application ID for Android, referenced from AndroidManifest.xml's
/// `com.google.android.gms.ads.APPLICATION_ID` meta-data. Kept here too so
/// the mapping between app ID and ad-unit IDs lives in one file.
const String kumeleAdMobAppId = 'ca-app-pub-9468769011659394~6688457654';

/// Central mapping of Kumele's approved AdMob placements to ad-unit IDs.
///
/// Debug builds always use Google's official test unit so development never
/// serves (or accidentally clicks) a real ad. Do not put production IDs
/// directly in UI widgets — read them from here.
abstract final class KumeleAdUnits {
  static const _androidNativeTestUnit =
      'ca-app-pub-3940256099942544/2247696110';

  static String get localEvents {
    if (kDebugMode) return _androidNativeTestUnit;
    return 'ca-app-pub-9468769011659394/9211535365';
  }

  static String get notifications {
    if (kDebugMode) return _androidNativeTestUnit;
    return 'ca-app-pub-9468769011659394/4221978278';
  }

  /// No Blog unit has been created in AdMob yet. Do not guess or reuse the
  /// Local Events/Notifications unit — keep this placement disabled until a
  /// dedicated unit exists.
  static String? get blog => null;

  /// Native ad factory IDs registered in MainActivity.kt. These render the
  /// AdMob native ad using Kumele's own card layout (KumeleNativeAdFactory)
  /// instead of Google's generic native ad template, so both placements
  /// keep the same look whether the ad shown is from AdMob or first-party.
  static const String localEventsAdFactoryId = 'localEventsAdFactory';
  static const String notificationsAdFactoryId = 'notificationsAdFactory';
}
