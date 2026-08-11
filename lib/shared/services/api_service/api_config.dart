class ApiConfig {
  ApiConfig._();

  /// Supplied by CI, local launch commands, or the release build pipeline.
  /// Never fall back to a cleartext IP address in a distributable build.
  static const String host = String.fromEnvironment(
    'KUMELE_API_ORIGIN',
    defaultValue: 'http://84.247.131.180:3000',
  );
  static const String baseUrl = '$host/api/v1';
  static const int timeout = 30000;

  static const String socketUrl = String.fromEnvironment(
    'KUMELE_SOCKET_ORIGIN',
    defaultValue: host,
  );
  static const String aimlBaseUrl = String.fromEnvironment(
    'KUMELE_AIML_ORIGIN',
    defaultValue: 'http://84.247.131.180:8080',
  );
  static const String chatSocketNamespace = '/chat';
  static const List<String> socketTransports = ['polling', 'websocket'];

  static const String passkeyRpId = String.fromEnvironment(
    'KUMELE_PASSKEY_RP_ID',
    defaultValue: 'kumele.com',
  );

  static const String _kumeleStripePublishableKey = String.fromEnvironment(
    'KUMELE_STRIPE_PUBLISHABLE_KEY',
  );
  static const String _stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
  );
  static const String stripeMerchantIdentifier = String.fromEnvironment(
    'KUMELE_STRIPE_MERCHANT_ID',
    defaultValue: 'merchant.com.kumele.hobbies',
  );
  static const String _kumelePaypalClientId = String.fromEnvironment(
    'KUMELE_PAYPAL_CLIENT_ID',
  );
  static const String _paypalClientId = String.fromEnvironment(
    'PAYPAL_CLIENT_ID',
  );
  static const String paypalSecretKey = String.fromEnvironment(
    'KUMELE_PAYPAL_SECRET_KEY',
  );
  static const bool _kumelePaypalSandboxMode = bool.fromEnvironment(
    'KUMELE_PAYPAL_SANDBOX',
    defaultValue: true,
  );
  static const String paypalMode = String.fromEnvironment(
    'PAYPAL_MODE',
    defaultValue: '',
  );
  static const bool stripeGooglePayTestEnv = bool.fromEnvironment(
    'KUMELE_STRIPE_GOOGLE_PAY_TEST',
    defaultValue: true,
  );

  static String get stripePublishableKey =>
      _kumeleStripePublishableKey.isNotEmpty
          ? _kumeleStripePublishableKey
          : _stripePublishableKey;

  static String get paypalClientId => _kumelePaypalClientId.isNotEmpty
      ? _kumelePaypalClientId
      : _paypalClientId;

  static bool get paypalSandboxMode {
    final mode = paypalMode.trim().toLowerCase();
    if (mode.isNotEmpty) return mode != 'live' && mode != 'production';
    return _kumelePaypalSandboxMode;
  }

  static const bool networkDebugLoggingRequested = bool.fromEnvironment(
    'KUMELE_ENABLE_NETWORK_DEBUG_LOGS',
    defaultValue: false,
  );

  static const String assetLinksUrl =
      'https://$passkeyRpId/.well-known/assetlinks.json';

  static bool get isConfigured => host.isNotEmpty;

  static void validate() {
    _validateOrigin('KUMELE_API_ORIGIN', host);
    _validateOrigin('KUMELE_SOCKET_ORIGIN', socketUrl);

    if (passkeyRpId.isEmpty ||
        passkeyRpId.contains('://') ||
        RegExp(r'^\d{1,3}(\.\d{1,3}){3}$').hasMatch(passkeyRpId)) {
      throw StateError(
        'KUMELE_PASSKEY_RP_ID must be a domain name, not an IP address.',
      );
    }
  }

  // ponytail: https requirement dropped for local dev against a plain-http
  // IP backend. Restore `uri.scheme != 'https'` before a distributable build.
  static void _validateOrigin(String name, String value) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      throw StateError('$name must be a configured http(s):// origin.');
    }
    if (uri.path.isNotEmpty && uri.path != '/') {
      throw StateError('$name must not include a path.');
    }
  }
}
