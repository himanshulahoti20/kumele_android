abstract class DeleteAccountRepository {
  Future<String?> deleteAccount({
    required String password,
    required String reason,
    required bool confirmation,
  });
}
