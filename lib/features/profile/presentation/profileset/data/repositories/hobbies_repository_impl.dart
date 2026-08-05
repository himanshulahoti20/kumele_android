import 'package:kuemele/features/profile/presentation/profileset/data/datasources/hobbies_remote_data_source.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/user_hobby_preference.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/repositories/hobbies_repository.dart';

class HobbiesRepositoryImpl implements HobbiesRepository {
  HobbiesRepositoryImpl({HobbiesRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? HobbiesRemoteDataSource();

  final HobbiesRemoteDataSource _remoteDataSource;

  @override
  Future<List<String>> getHobbyCategoryNames() async {
    final categories = await getHobbyCategories();

    return categories
        .map((category) => category.name)
        .where((name) => name.trim().isNotEmpty)
        .toList();
  }

  @override
  Future<List<HobbyCategoryModel>> getHobbyCategories() async {
    final categories = await _remoteDataSource.fetchCategories();

    return categories.where((category) => category.isActive).toList()
      ..sort((left, right) => left.sortOrder.compareTo(right.sortOrder));
  }

  @override
  Future<List<HobbyInterest>> getHobbyInterests() async {
    final categories = await _remoteDataSource.fetchCategories();

    final List<HobbyInterest> list = [];
    for (final category in categories) {
      if (!category.isActive) continue;
      for (final hobby in category.hobbies) {
        if (!hobby.isActive) continue;

        final hobbyIcon = (hobby.icon != null && hobby.icon!.isNotEmpty)
            ? hobby.icon
            : category.icon;

        list.add(HobbyInterest(
          id: hobby.id,
          categoryId: hobby.categoryId,
          name: hobby.name,
          slug: hobby.slug,
          icon: hobbyIcon,
          color: category.color,
        ));
      }
    }
    return list;
  }

  @override
  Future<List<UserHobbyPreference>> getUserHobbies({
    required String userId,
  }) async {
    final preferences = await _remoteDataSource.fetchUserHobbies(
      userId: userId,
    );

    return preferences
        .map((preference) => preference.toEntity())
        .where((preference) => preference.hobbyId.isNotEmpty)
        .toList();
  }

  @override
  Future<String> updateUserHobbies({
    required String userId,
    required List<UserHobbyPreference> hobbies,
  }) {
    return _remoteDataSource.updateUserHobbies(
      userId: userId,
      hobbies: hobbies,
    );
  }
}
