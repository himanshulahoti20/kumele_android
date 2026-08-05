import 'package:kuemele/shared/models/two_factor_setup_data.dart';

abstract class TwoFactorSetupRepository {
  Future<TwoFactorSetupData?> setup();

  Future<void> enable({required String code});

  Future<void> disable({required String code});
}
