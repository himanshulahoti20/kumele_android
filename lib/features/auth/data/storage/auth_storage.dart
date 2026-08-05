import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/utils/storage_util.dart';

class AuthStorage {
  const AuthStorage();

  Future<void> saveSession(AuthSession session) async {
    await StorageUtil.storeItem(StorageKey.AUTH_SESSION, session.toJson());
    await StorageUtil.storeItem(StorageKey.USER_TOKEN, session.accessToken);
    if (session.refreshToken != null) {
      await StorageUtil.storeItem(
        StorageKey.USER_REFRESH_TOKEN,
        session.refreshToken,
      );
    }
  }

  Future<AuthSession?> loadSession() async {
    final stored = await StorageUtil.retrieveItem(StorageKey.AUTH_SESSION);
    if (stored is Map) {
      return AuthSession.fromJson(Map<String, dynamic>.from(stored));
    }

    final accessToken =
        await StorageUtil.retrieveItem(StorageKey.USER_TOKEN) as String?;
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    final refreshToken =
        await StorageUtil.retrieveItem(StorageKey.USER_REFRESH_TOKEN)
            as String?;

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> updateTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final session = await loadSession();
    if (session != null) {
      await saveSession(
        session.copyWith(
          accessToken: accessToken,
          refreshToken: refreshToken ?? session.refreshToken,
        ),
      );
      return;
    }

    await StorageUtil.storeItem(StorageKey.USER_TOKEN, accessToken);
    if (refreshToken != null) {
      await StorageUtil.storeItem(StorageKey.USER_REFRESH_TOKEN, refreshToken);
    }
  }

  Future<void> clear() async {
    await StorageUtil.deleteItem(StorageKey.AUTH_SESSION);
    await StorageUtil.deleteItem(StorageKey.USER_TOKEN);
    await StorageUtil.deleteItem(StorageKey.USER_REFRESH_TOKEN);
  }
}
