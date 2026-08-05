import 'package:kuemele/features/profile/presentation/security/domain/repositories/two_factor_setup_repository.dart';
import 'package:kuemele/shared/models/two_factor_setup_data.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';

class TwoFactorSetupRepositoryImpl implements TwoFactorSetupRepository {
  @override
  Future<TwoFactorSetupData?> setup() => AuthenRepo.setup2FA();

  @override
  Future<void> enable({required String code}) {
    return AuthenRepo.enable2FA(code: code);
  }

  @override
  Future<void> disable({required String code}) {
    return AuthenRepo.disable2FA(code: code);
  }
}
