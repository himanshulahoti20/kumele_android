import 'package:kuemele/features/profile/presentation/security/domain/repositories/change_password_repository.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return ProfileRepo.changePassword(
      oldPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
