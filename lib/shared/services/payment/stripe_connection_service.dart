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

  /// The backend rejects custom schemes: these are its own signed HTTPS bridges,
  /// which redirect to the native `kumele://` destination for `target: native`.
  static const stripeConnectReturnUrl =
      'https://api.kumele.com/api/v1/payments/stripe/connect/return';
  static const stripeConnectRefreshUrl =
      'https://api.kumele.com/api/v1/payments/stripe/connect/refresh';
}
