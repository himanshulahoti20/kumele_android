import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/features/auth/data/storage/auth_storage.dart';
import 'package:kuemele/shared/utils/storage_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await StorageUtil.init();
    await StorageUtil.deleteAll();
  });

  test('loadSession keeps legacy refresh token when auth session lacks it',
      () async {
    FlutterSecureStorage.setMockInitialValues({
      StorageKey.AUTH_SESSION: jsonEncode({'access_token': 'expired-access'}),
      StorageKey.USER_REFRESH_TOKEN: 'valid-refresh',
    });

    final session = await const AuthStorage().loadSession();

    expect(session?.accessToken, 'expired-access');
    expect(session?.refreshToken, 'valid-refresh');
  });
}
