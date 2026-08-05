import 'package:kuemele/shared/models/authen_models.dart';

abstract class EditProfileRepository {
  Future<UserModel> updateProfile({
    required String userId,
    required UserModel body,
  });

  Future<String> uploadProfileImage(String filePath);
}
