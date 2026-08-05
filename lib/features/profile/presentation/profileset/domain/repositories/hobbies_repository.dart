import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/user_hobby_preference.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';

abstract class HobbiesRepository {
  Future<List<String>> getHobbyCategoryNames();

  Future<List<HobbyCategoryModel>> getHobbyCategories();

  Future<List<HobbyInterest>> getHobbyInterests();

  Future<List<UserHobbyPreference>> getUserHobbies({required String userId});

  Future<String> updateUserHobbies({
    required String userId,
    required List<UserHobbyPreference> hobbies,
  });
}
