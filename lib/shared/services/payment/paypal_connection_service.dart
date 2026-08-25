import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';

class PayPalConnectionStatus {
  const PayPalConnectionStatus({
    required this.isConnected,
    this.paypalPayerId,
    this.email,
  });

  final bool isConnected;
  final String? paypalPayerId;
  final String? email;
}

class PayPalConnectionService {
  PayPalConnectionService._();

  /// Live status from `GET /payments/paypal/connect/status` — no more local
  /// "did we last see a successful connect" caching; the backend is always
  /// asked directly, so this reflects a disconnect from another
  /// device/session too.
  static Future<PayPalConnectionStatus> loadStatus() async {
    final status = await Web3Repo.getPayPalConnectStatus();
    return PayPalConnectionStatus(
      isConnected: status.connected,
      paypalPayerId: status.paypalPayerId,
      email: status.paypalEmail,
    );
  }

  static Future<String?> createLoginUrl() async {
    final url = await Web3Repo.getPayPalConnectLoginUrl();
    final trimmed = url?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static Future<bool> disconnect() async {
    return Web3Repo.disconnectPayPal();
  }
}
