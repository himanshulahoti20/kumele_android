import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog.dart';

void main() {
  test('generated API catalog covers the live backend contract', () {
    expect(
      GeneratedApiCatalog.all,
      hasLength(GeneratedApiCatalog.contractOperationCount),
    );
    expect(
      GeneratedApiCatalog.all.map((descriptor) => descriptor.routeKey).toSet(),
      hasLength(GeneratedApiCatalog.contractOperationCount),
    );
  });

  test('network configuration never falls back to cleartext', () {
    if (ApiConfig.isConfigured) {
      expect(ApiConfig.validate, returnsNormally);
    } else {
      expect(ApiConfig.validate, throwsStateError);
    }
  });
}
