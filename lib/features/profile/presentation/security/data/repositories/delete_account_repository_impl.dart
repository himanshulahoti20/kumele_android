import 'package:kuemele/features/profile/presentation/security/domain/repositories/delete_account_repository.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';

class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  @override
  Future<String?> deleteAccount({
    required String password,
    required String reason,
    required bool confirmation,
  }) {
    return ProfileRepo.deleteAccount(
      password: password,
      reason: reason,
      confirmation: confirmation,
    );
  }
}
