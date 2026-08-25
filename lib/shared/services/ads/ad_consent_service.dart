import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Gathers Google's UMP consent (limited/non-personalized ads only, per
/// Kumele's no-tracking policy) and starts the Mobile Ads SDK only once the
/// user is allowed to be shown a Google ad request.
///
/// Call [gatherConsentAndStartAds] once from app bootstrap, before any ad
/// widget is built. Placements must not initialize or load an ad before this
/// completes — if consent is unavailable or rejected, they should render the
/// Kumele first-party fallback instead.
class AdConsentService {
  AdConsentService._();

  static final AdConsentService instance = AdConsentService._();

  bool _started = false;

  Future<void> gatherConsentAndStartAds() async {
    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((formError) async {
          if (formError != null) return;
          await _startOnlyWhenAllowed();
        });
      },
      (formError) {
        // Keep Google ads disabled; placements fall back to first-party ads.
      },
    );
  }

  Future<void> _startOnlyWhenAllowed() async {
    if (_started) return;
    final allowed = await ConsentInformation.instance.canRequestAds();
    if (!allowed) return;

    _started = true;
    await MobileAds.instance.initialize();
  }

  /// Returns whether a Google ad request may currently be made. Placements
  /// must check this (and that the SDK has started) before loading an ad.
  Future<bool> get canRequestAds =>
      _started ? ConsentInformation.instance.canRequestAds() : Future.value(false);

  /// Reopens Google's consent management "Privacy choices" screen. Wire this
  /// to a persistent Settings entry.
  Future<void> showPrivacyChoices() async {
    await ConsentForm.showPrivacyOptionsForm((formError) {});
  }
}
