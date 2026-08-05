import 'package:kuemele/features/profile/presentation/profileset/domain/repositories/edit_profile_repository.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';

class EditProfileRepositoryImpl implements EditProfileRepository {
  @override
  Future<UserModel> updateProfile({
    required String userId,
    required UserModel body,
  }) async {
    final response = await ProfileRepo.updateUserProfileById(
      userId: userId,
      body: body,
    );

    if (response?.data == null) {
      throw ApiException(error: 'Failed to update profile.');
    }

    return response!.data!;
  }

  @override
  Future<String> uploadProfileImage(String filePath) {
    return ProfileRepo.uploadProfileImage(filePath);
  }
}
