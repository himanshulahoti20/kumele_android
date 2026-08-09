import 'dart:convert';

import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/utils/storage_util.dart';

class PayPalConnectionStatus {
  const PayPalConnectionStatus({
    required this.isConnected,
    this.accountId,
    this.connectedAt,
  });

  final bool isConnected;
  final String? accountId;
  final DateTime? connectedAt;
}

class PayPalConnectionSetup {
  const PayPalConnectionSetup({
    required this.approvalUrl,
    required this.setupTokenId,
  });

  final String approvalUrl;
  final String setupTokenId;
}

class PayPalConnectionService {
  PayPalConnectionService._();

  static const _storageKey = 'host_paypal_connection';

  static Future<PayPalConnectionStatus> loadStatus() async {
    final user = InjectionHelper.profileCubit.userData;
    final backendId = user?.paypalMerchantId?.trim();
    if (user?.isPayPalConnected == true) {
      return PayPalConnectionStatus(isConnected: true, accountId: backendId);
    }

    final stored = await StorageUtil.retrieveItem(_storageKey);
    if (stored is! String || stored.isEmpty) {
      return const PayPalConnectionStatus(isConnected: false);
    }

    try {
      final json = jsonDecode(stored);
      if (json is! Map) return const PayPalConnectionStatus(isConnected: false);
      final accountId = json['accountId']?.toString();
      if (accountId == null || accountId.isEmpty) {
        return const PayPalConnectionStatus(isConnected: false);
      }

      return PayPalConnectionStatus(
        isConnected: true,
        accountId: accountId,
        connectedAt: DateTime.tryParse(json['connectedAt']?.toString() ?? ''),
      );
    } on FormatException {
      return const PayPalConnectionStatus(isConnected: false);
    }
  }

  static Future<PayPalConnectionSetup?> createSetup() async {
    final setup = await Web3Repo.createPayPalVaultSetup();
    if (setup == null) return null;
    final approvalUrl = setup.approvalUrl?.trim();
    final setupTokenId = setup.setupTokenId?.trim();
    if (approvalUrl == null ||
        approvalUrl.isEmpty ||
        setupTokenId == null ||
        setupTokenId.isEmpty) {
      return null;
    }
    return PayPalConnectionSetup(
      approvalUrl: approvalUrl,
      setupTokenId: setupTokenId,
    );
  }

  static Future<void> markConnected(String accountId) async {
    await StorageUtil.storeItem(
      _storageKey,
      jsonEncode({
        'accountId': accountId,
        'connectedAt': DateTime.now().toIso8601String(),
      }),
    );
  }
}
