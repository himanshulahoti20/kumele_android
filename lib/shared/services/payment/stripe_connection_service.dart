import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';

/// Mirrors [PayPalConnectionService] for Stripe Connect Express.
class StripeConnectionService {
  StripeConnectionService._();

  /// Live status from `GET /payments/stripe/connect/status` — always asked
  /// directly, so this reflects a disconnect from another device/session.
  static Future<StripeConnectStatus> loadStatus() async {
    return Web3Repo.getStripeConnectStatus();
  }

  static Future<String?> createOnboardingUrl() {
    return Web3Repo.createStripeConnectOnboarding(
      returnUrl: stripeConnectReturnUrl,
      refreshUrl: stripeConnectRefreshUrl,
    );
  }

  static Future<bool> disconnect() {
    return Web3Repo.disconnectStripeConnect();
  }

  /// Same `kumele` custom scheme PayPal's connect flow already uses — Stripe's
  /// hosted onboarding accepts it directly, no backend bridge page needed.
  static const stripeConnectReturnUrl = 'kumele://stripe-connect-return';
  static const stripeConnectRefreshUrl = 'kumele://stripe-connect-refresh';
}
