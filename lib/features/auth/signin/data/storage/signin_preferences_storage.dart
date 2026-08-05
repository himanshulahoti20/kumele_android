import 'package:kuemele/shared/utils/storage_util.dart';

class SigninPreferences {
  const SigninPreferences({
    this.rememberMe = false,
    this.email,
  });

  final bool rememberMe;
  final String? email;
}

class SigninPreferencesStorage {
  const SigninPreferencesStorage();

  Future<SigninPreferences> load() async {
    final rememberMe =
        await StorageUtil.retrieveItem(StorageKey.SIGNIN_REMEMBER_ME);
    final email =
        await StorageUtil.retrieveItem(StorageKey.SIGNIN_REMEMBERED_EMAIL);

    return SigninPreferences(
      rememberMe: rememberMe == true,
      email: email is String && email.isNotEmpty ? email : null,
    );
  }

  Future<void> save({
    required bool rememberMe,
    required String email,
  }) async {
    await StorageUtil.storeItem(StorageKey.SIGNIN_REMEMBER_ME, rememberMe);
    if (rememberMe && email.isNotEmpty) {
      await StorageUtil.storeItem(StorageKey.SIGNIN_REMEMBERED_EMAIL, email);
      return;
    }

    await StorageUtil.deleteItem(StorageKey.SIGNIN_REMEMBERED_EMAIL);
  }

  Future<void> clear() async {
    await StorageUtil.deleteItem(StorageKey.SIGNIN_REMEMBER_ME);
    await StorageUtil.deleteItem(StorageKey.SIGNIN_REMEMBERED_EMAIL);
  }
}
